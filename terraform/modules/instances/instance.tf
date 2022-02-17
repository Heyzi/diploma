variable "ENV" {
}

variable "INSTANCE_TYPE" {
  default = "t2.micro"
}

variable "PUBLIC_SUBNETS" {
  type = list
}

variable "VPC_ID" {
}

variable "PATH_TO_PUBLIC_KEY" {
  default = "~/.ssh/id_rsa.pub"
}

variable "AMI" {
  default = "ami-0bf84c42e04519c85"
}

resource "aws_instance" "instance" {
  instance_type          = var.INSTANCE_TYPE
  ami                    = "${var.AMI}"
  subnet_id              = element(var.PUBLIC_SUBNETS, 0)
  vpc_security_group_ids = [aws_security_group.allow-ssh.id]
  key_name               = aws_key_pair.mykp.key_name

  tags = {
    Name         = "instance-${var.ENV}"
    Environmnent = var.ENV
  }
}

resource "aws_key_pair" "mykp" {
  key_name   = "mykp-${var.ENV}"
  public_key = file("${var.PATH_TO_PUBLIC_KEY}")
}

