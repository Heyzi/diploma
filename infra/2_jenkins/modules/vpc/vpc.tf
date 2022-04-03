terraform {
  required_version = ">= 0.12"
}


resource "aws_vpc" "default_vpc" {
  cidr_block       = var.CIDR_BLOCK
  tags = {
    Name = "${var.ENV}-vpc"
  }
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.default_vpc.id
}
output "default_rt_id" {
  description = "The ID of the RT"
  value       = aws_vpc.default_vpc.default_route_table_id
}

