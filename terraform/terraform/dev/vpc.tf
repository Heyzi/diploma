#vpc
resource "aws_vpc" "my-dev-vpc" {
    cidr_block = "10.100.0.0/16"

    tags = {
        Name  = "${var.ENV}-vpc"
        Owner = "${var.OWNER}"
    }
}
#subnets
resource "aws_subnet" "my-dev-subnet" {
  count                   = "${length(var.SUBNETS)}"
  vpc_id                  = "${aws_vpc.my-dev-vpc.id}"
  cidr_block              = "${var.SUBNETS[count.index]}"
  availability_zone       = "eu-west-1a"
  map_public_ip_on_launch = false
  tags = {
        Name  = "${var.ENV}-subnet-${var.SUBNETS[count.index]}"
        Owner = "${var.OWNER}"
    }
}