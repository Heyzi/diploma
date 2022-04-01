terraform {
  required_version = ">= 0.12"
}
variable "ENV" {}
variable "VPC_ID" {}
variable "DEF_RT" {}
variable "CIDR_BLOCK" {}
variable "SUBNETS_CIDR" {}
variable "AZ" {}

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

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = length(var.public_subnets_cidr)
  cidr_block              = element(var.public_subnets_cidr, count.index)
  availability_zone       = element(var.AZ, count.index)
#  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.ENV}-${element(var.AZ, count.index)}-subnet"
    Environment = "${var.ENV}"
  }
}


