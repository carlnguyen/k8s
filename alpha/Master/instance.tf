variable "region" {}
###########
provider "aws" {
  version = "~> 2.0"
  region  = "${var.region}"
}
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = "ubuntu/images/hvm-instance/ubuntu-bionic-18.04-amd64-server-*"
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}
########### Variable for master node
variable "EC2_TYPE" {}
variable "AWS_KEYPAIR" {}
variable "EC2_TAG" {}
resource "aws_instance" "MasterNode" {
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "${var.EC2_TYPE}"
  key_name      = "${var.AWS_KEYPAIR}"

  tags = {
    Name = "${var.EC2_TAG}"
  }
  provisioner "file" {
    source      = "../ansible/master-components.yaml"
    destination = "/home/ubuntu/ansible/"
  }
  provisioner "remote-exec" {
    inline = ["sudo apt install python -y"],
    inline = ["sudo apt install ansible -y"]
  }
  connection {
    host        = "${aws_instance.MasterNode.public_ip}"
    user        = "ubuntu"
    private_key = "${var.AWS_KEYPAIR}"
  }
  provisioner "local-exec" {
    command = "ansible-playbook -u ubuntu /home/ubuntu/ansible/master-components.yaml"
  }
}