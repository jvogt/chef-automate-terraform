/*
  Web Servers
*/

resource "aws_security_group" "public" {
  name = "public"
  description = "Allow incoming HTTP connections."

  vpc_id = "${aws_vpc.default.id}"

  tags {
    Name = "${var.aws_username}-automate-public"
    created-by = "${var.full_name}"
    user = "${var.aws_username}"
  }
}


resource "aws_security_group_rule" "allow_80_from_world" {
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.public.id}"
}

resource "aws_security_group_rule" "allow_443_from_world" {
  type = "ingress"
  from_port = 443
  to_port = 443
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.public.id}"
}

resource "aws_security_group_rule" "public_allow_22_from_world" {
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.public.id}"
}

resource "aws_security_group_rule" "public_allow_outbound_to_world" {
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.public.id}"
}


resource "aws_security_group_rule" "public_allow_all_from_private" {
  type            = "ingress"
  from_port       = 0
  to_port         = 0
  protocol        = "-1"
  source_security_group_id = "${aws_security_group.private.id}"
  security_group_id = "${aws_security_group.public.id}"
}

resource "aws_instance" "automate-server" {
  ami = "${lookup(var.amis, var.aws_region)}"
  availability_zone = "${var.aws_region}a"
  instance_type = "m3.large"
  key_name = "${var.aws_key_name}"
  vpc_security_group_ids = ["${aws_security_group.public.id}"]
  subnet_id = "${aws_subnet.a-public.id}"
  associate_public_ip_address = true
  source_dest_check = false

  tags {
    Name = "${var.aws_username}-automate-automate-server"
    created-by = "${var.full_name}"
    user = "${var.aws_username}"
  }
}

resource "aws_eip" "automate-server" {
  instance = "${aws_instance.automate-server.id}"
  vpc = true
}

output "automate-server-ip" {
  value = "${aws_eip.automate-server.public_ip}"
}

resource "aws_instance" "chef-server" {
  ami = "${lookup(var.amis, var.aws_region)}"
  availability_zone = "${var.aws_region}a"
  instance_type = "m3.large"
  key_name = "${var.aws_key_name}"
  vpc_security_group_ids = ["${aws_security_group.public.id}"]
  subnet_id = "${aws_subnet.a-public.id}"
  associate_public_ip_address = true
  source_dest_check = false

  tags {
    Name = "${var.aws_username}-automate-chef-server"
    created-by = "${var.full_name}"
    user = "${var.aws_username}"
  }
}

resource "aws_eip" "chef-server" {
  instance = "${aws_instance.chef-server.id}"
  vpc = true
}

output "chef-server-ip" {
  value = "${aws_eip.chef-server.public_ip}"
}
