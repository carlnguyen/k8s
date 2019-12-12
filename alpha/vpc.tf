resource "aws_vpc" "TACO_VPC" {
  cidr_block = "${var.CIDR_VPC}"
  tags = {
    Name = "${var.VPC_TAG}"
  }
}
resource "aws_internet_gateway" "TACO_GW" {
  vpc_id = "${aws_vpc.TACO_VPC.id}"

  tags = {
    Name = "TACO_GW"
  }
}
resource "aws_subnet" "TACO_SUBNET" {
  vpc_id                  = "${aws_vpc.TACO_VPC.id}"
  cidr_block              = "${var.PUBLIC_SUBNET}"
  availability_zone       = "${var.AVAILABILITY_ZONE}"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.PUBLIC_SUBNET_TAG}"
  }
}
resource "aws_route_table" "RTB_VPC_TACO" {
  vpc_id = "${aws_vpc.TACO_VPC.id}"

  route {
    cidr_block = "${var.RTB_CIDR}"
    gateway_id = "${aws_internet_gateway.TACO_GW.id}"
  }
}
resource "aws_route_table_association" "TACO_ASSOCIATE" {
  subnet_id      = "${aws_subnet.TACO_SUBNET.id}"
  route_table_id = "${aws_route_table.RTB_VPC_TACO.id}"
}
# variables
variable "CIDR_VPC" {}
variable "VPC_TAG" {}
variable "PUBLIC_SUBNET" {}
variable "AVAILABILITY_ZONE" {}
variable "PUBLIC_SUBNET_TAG" {}
variable "RTB_CIDR" {}