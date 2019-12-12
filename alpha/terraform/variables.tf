###### variables
variable "CIDR_VPC" {
    default = "10.0.0.0/16"
}
variable "PUBLIC_SUBNET" {
    default = "10.0.12.0/24"
}
variable "AVAILABILITY_ZONE" {
    default = "ap-southeast-1"
}
variable "RTB_CIDR" {
    default = "0.0.0.0/9"
}
variable "ingress_cird" {
  default = "0.0.0.0/0"
}
variable "egress_cidr" {
  default = "0.0.0.0/0"
}
