terraform {
  required_version = ">= 0.12"
}
variable "ENV" {
}
variable "VPC_ID" {
}
variable "DEF_RT" {
}
variable "CIDR_BLOCK" {
}
variable "AZ" {
}

resource "aws_internet_gateway" "default_igw" {
  vpc_id = var.VPC_ID
  tags = {
    Name = "${var.ENV}-igw"
  }
}
resource "aws_default_route_table" "default_route_table" {
  default_route_table_id = var.DEF_RT

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.default_igw.id
  }

  tags = {
    Name = "${var.ENV}-route_table"
  }
}

resource "aws_subnet" "main_subnet" {
  vpc_id                  = var.VPC_ID
  cidr_block              = var.CIDR_BLOCK
  availability_zone       = var.AZ

  tags = {
    Name = "${var.ENV}-subnet"
  }
}

output "subnet_id" {
  description = "Subnet id"
  value       = aws_subnet.main_subnet.id
}

