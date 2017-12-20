/*
  Database Servers
*/
resource "aws_security_group" "private" {
  name = "private"
  description = "Allow incoming connections."

  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }

  egress { # all outbound
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = "${aws_vpc.default.id}"

  tags {
    Name = "PrivateSG"
  }
}

resource "aws_security_group_rule" "allow_all_from_public" {
  type            = "ingress"
  from_port       = 0
  to_port         = 0
  protocol        = "-1"
  source_security_group_id = "${aws_security_group.public.id}"
  security_group_id = "${aws_security_group.private.id}"
}

resource "aws_instance" "builder-1" {
  ami = "${lookup(var.amis, var.aws_region)}"
  availability_zone = "${var.aws_region}a"
  instance_type = "m1.small"
  key_name = "${var.aws_key_name}"
  vpc_security_group_ids = ["${aws_security_group.private.id}"]
  subnet_id = "${aws_subnet.a-private.id}"
  source_dest_check = false

  tags {
    Name = "Builder 1"
  }
}
resource "aws_instance" "builder-2" {
  ami = "${lookup(var.amis, var.aws_region)}"
  availability_zone = "${var.aws_region}a"
  instance_type = "m1.small"
  key_name = "${var.aws_key_name}"
  vpc_security_group_ids = ["${aws_security_group.private.id}"]
  subnet_id = "${aws_subnet.a-private.id}"
  source_dest_check = false

  tags {
    Name = "Builder 2"
  }
}
resource "aws_instance" "builder-3" {
  ami = "${lookup(var.amis, var.aws_region)}"
  availability_zone = "${var.aws_region}a"
  instance_type = "m1.small"
  key_name = "${var.aws_key_name}"
  vpc_security_group_ids = ["${aws_security_group.private.id}"]
  subnet_id = "${aws_subnet.a-private.id}"
  source_dest_check = false

  tags {
    Name = "Builder 3"
  }
}