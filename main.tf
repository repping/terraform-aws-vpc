resource "aws_vpc" "main" {
  cidr_block = var.cidr_block

  tags = var.tags
}


resource "aws_subnet" "public" {
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "${var.region}b" # TODO cleanup
  map_public_ip_on_launch = var.public_subnet
  vpc_id                  = aws_vpc.main.id

  tags = var.tags
}


resource "aws_internet_gateway" "main" {
  count  = var.public_subnet ? 1 : 0
  vpc_id = aws_vpc.main.id

  tags = var.tags
}


resource "aws_route_table" "main" {
  count  = var.public_subnet ? 1 : 0
  vpc_id = aws_vpc.main.id

  tags = var.tags
}

resource "aws_route" "egress_all" {
  count                  = var.public_subnet ? 1 : 0
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main[0].id
  route_table_id         = aws_route_table.main[0].id
}


resource "aws_route_table_association" "egress_all" {
  count          = var.public_subnet ? 1 : 0
  route_table_id = aws_route_table.main[0].id
  subnet_id      = aws_subnet.public.id
}


resource "aws_subnet" "private" {
  cidr_block        = "10.0.1.0/24"
  availability_zone = "${var.region}a" # TODO cleanup
  vpc_id            = aws_vpc.main.id

  tags = var.tags
}


resource "aws_db_subnet_group" "default" {
  subnet_ids = [aws_subnet.private.id, aws_subnet.public.id] # TODO two private subnets instead?
}


resource "aws_security_group" "vpc" {
  description = "Main security group, allows all outgoing"
  name        = "VPC"
  vpc_id      = aws_vpc.main.id

  tags = var.tags
}


resource "aws_security_group_rule" "ingress_ssh" {
  type              = "ingress"
  description       = "allow inbound ssh"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = [var.ssh_allowed_from]
  security_group_id = aws_security_group.vpc.id
}


resource "aws_security_group_rule" "egress_all" {
  type              = "egress"
  description       = "allow all outbound"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.vpc.id
}