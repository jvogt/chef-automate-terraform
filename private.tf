/*
  Database Servers
*/
resource "aws_security_group" "private" {
  name = "private"
  description = "Allow incoming connections."

  vpc_id = "${aws_vpc.default.id}"

  tags {
    Name = "${var.aws_username}-automate-private"
    created-by = "${var.full_name}"
    user = "${var.aws_username}"
  }
}

resource "aws_security_group_rule" "private_allow_outbound_to_world" {
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.private.id}"
}

resource "aws_security_group_rule" "private_allow_all_from_vpc" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["${var.vpc_cidr}"]
  security_group_id = "${aws_security_group.private.id}"
}

resource "aws_instance" "runner-01" {
  ami = "${lookup(var.amis, var.aws_region)}"
  availability_zone = "${var.aws_region}a"
  instance_type = "m1.small"
  key_name = "${var.aws_key_name}"
  vpc_security_group_ids = ["${aws_security_group.private.id}"]
  subnet_id = "${aws_subnet.a-private.id}"
  source_dest_check = false
  root_block_device {
    volume_size = "60"
  }

  tags {
    Name = "${var.aws_username}-automate-runner-01"
    created-by = "${var.full_name}"
    user = "${var.aws_username}"
  }
}

resource "aws_instance" "runner-02" {
  ami = "${lookup(var.amis, var.aws_region)}"
  availability_zone = "${var.aws_region}a"
  instance_type = "m1.small"
  key_name = "${var.aws_key_name}"
  vpc_security_group_ids = ["${aws_security_group.private.id}"]
  subnet_id = "${aws_subnet.a-private.id}"
  source_dest_check = false
  root_block_device {
    volume_size = "60"
  }

  tags {
    Name = "${var.aws_username}-automate-runner-02"
    created-by = "${var.full_name}"
    user = "${var.aws_username}"
  }
}