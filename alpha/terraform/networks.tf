variable "region" {}
provider "aws" {
  version = "~> 2.0"
  region  = "${var.region}"
}

resource "aws_vpc" "vpc_k8s" {
  cidr_block = "${var.CIDR_VPC}"
  tags = {
    Name = "vpc_k8s"
  }
}
resource "aws_internet_gateway" "gw_k8s" {
  vpc_id = "${aws_vpc.vpc_k8s.id}"

  tags = {
    Name = "gw_k8s"
  }
}
resource "aws_subnet" "subnet_k8s" {
  vpc_id                  = "${aws_vpc.vpc_k8s.id}"
  cidr_block              = "${var.CIDR_VPC}"
  availability_zone       = "${var.AVAILABILITY_ZONE}"
  map_public_ip_on_launch = true

  tags = {
    Name = "subnet_k8s"
  }
}
resource "aws-security_group" "sec_group_k8s" {
  vpc_id      = "${var.CIDR_VPC.id}"
  name        = "sec_group_k8s"
  description = "testing"
  tags {
    name = "sec_group-k8s"
  }
  ingress {
    protocol    = "TCP"
    from_port   = "443"
    to_port     = "443"
    cidr_blocks = ["0.0.0.0/16"]
  }
  ingress {
    protocol    = "TCP"
    from_port   = "22"
    to_port     = "22"
    cidr_blocks = ["0.0.0.0/16"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_route_table" "rtb_k8s" {
  vpc_id = "${aws_vpc.vpc_k8s.id}"

  route {
    cidr_block = "${var.RTB_CIDR}"
    gateway_id = "${aws_internet_gateway.gw_k8s.id}"
  }
}
resource "aws_route_table_association" "TACO_ASSOCIATE" {
  subnet_id      = "${aws_subnet.subnet_k8s.id}"
  route_table_id = "${aws_route_table.rtb_k8s.id}"
}
