terraform {
  required_version = ">= 0.12"
}
variable "ENV" {
}
variable "INSTANCE_TYPE" {
}
variable "VPC_ID" {
}
variable "PUB_KEY" {
}
variable "INGRESS_RULES" {
}
variable "EGRESS_RULES" {
}
variable "SUBNET_ID" {
}

data "aws_ami" "ami_selected" {
  most_recent = true
  filter {
    name   = "name"
    values = ["RHEL-8*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["309956199498"]
}

resource "aws_instance" "default_instance" {
  ami                         = data.aws_ami.ami_selected.id
  instance_type               = var.INSTANCE_TYPE
  subnet_id                   = var.SUBNET_ID
  security_groups             = ["${aws_security_group.default_sg.id}"]
  key_name                    = aws_key_pair.jenkins_key.key_name
  user_data                   = file("jenkins_install.sh")
  tags = {
    Name = "${var.ENV}-instance"
  }
}

resource "aws_security_group" "default_sg" {
  name        = "Jenkins Security Group"
  description = "Allow traffic to access Jenkins instrance"
  vpc_id      = var.VPC_ID

  dynamic "ingress" {
    iterator = port
    for_each = var.INGRESS_RULES
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  dynamic "egress" {
    iterator = port
    for_each = var.EGRESS_RULES
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
   tags = {

    Name = "${var.ENV}-security_group"
  }
}

resource "aws_eip" "default_eip" {
  instance = aws_instance.default_instance.id
  vpc      = true
}
output "public_ip" {
  description = "Contains the public IP address"
  value       = aws_eip.default_eip.public_ip
}

resource "aws_key_pair" "jenkins_key" {
  key_name   = "jenkins_key"
  public_key = file("${var.PUB_KEY}")
 tags = {

    Name = "${var.ENV}-key"
  }
}


