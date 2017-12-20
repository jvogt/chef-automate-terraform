resource "aws_vpc" "default" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  enable_dns_support = true
  tags {
    Name = "${var.aws_username}-automate-vpc"
    created-by = "${var.full_name}"
    user = "${var.aws_username}"
  }
}

resource "aws_subnet" "a-public" {
  vpc_id = "${aws_vpc.default.id}"
  cidr_block = "${var.public_subnet_cidr}"
  map_public_ip_on_launch = true
  availability_zone = "${var.aws_region}a"

  tags {
    Name = "${var.aws_username}-automate-public-${var.aws_region}a"
    created-by = "${var.full_name}"
    user = "${var.aws_username}"
  }
}

resource "aws_subnet" "a-private" {
  vpc_id = "${aws_vpc.default.id}"
  cidr_block = "${var.private_subnet_cidr}"
  availability_zone = "${var.aws_region}a"
  tags = {
    Name = "${var.aws_username}-automate-private-${var.aws_region}a"
    created-by = "${var.full_name}"
    user = "${var.aws_username}"
  }
}

resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.default.id}"
}

resource "aws_route" "internet_access" {
  route_table_id         = "${aws_vpc.default.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.default.id}"
}

resource "aws_eip" "nat_eip" {
  vpc      = true
  depends_on = ["aws_internet_gateway.default"]
}

resource "aws_nat_gateway" "nat" {
  allocation_id = "${aws_eip.nat_eip.id}"
  subnet_id = "${aws_subnet.a-public.id}"
  depends_on = ["aws_internet_gateway.default"]
}

resource "aws_route_table" "private_route_table" {
  vpc_id = "${aws_vpc.default.id}"

  tags {
    Name = "${var.aws_username}-private-route-table"
    created-by = "${var.full_name}"
    user = "${var.aws_username}"
  }
}
 
resource "aws_route" "private_route" {
  route_table_id  = "${aws_route_table.private_route_table.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = "${aws_nat_gateway.nat.id}"
}

# Associate subnet a-public to public route table
resource "aws_route_table_association" "a-public_association" {
  subnet_id = "${aws_subnet.a-public.id}"
  route_table_id = "${aws_vpc.default.main_route_table_id}"
}
 
# Associate subnet a-private to private route table
resource "aws_route_table_association" "a-private_association" {
  subnet_id = "${aws_subnet.a-private.id}"
  route_table_id = "${aws_route_table.private_route_table.id}"
}
