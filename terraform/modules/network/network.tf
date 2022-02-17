#IGW
resource "aws_internet_gateway" "igw" {
    vpc_id = "${aws_vpc.main-vpc.id}"

    tags = {
      Name  = "igw-${var.ENV}"
    }
}

#route to inet
resource "aws_route_table" "route" {
    vpc_id = "${aws_vpc.main-vpc.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.igw.id}"
    }

    tags = {
        Name  = "${var.ENV}-rt"
    }
}

# add route to subnet
resource "aws_route_table_association" "my-dev-ass-to-sub" {
    subnet_id = "${aws_subnet.public_subnets.id}"
    route_table_id = "${aws_route_table.rt.id}"
}

# security group
resource "aws_security_group" "allow-ssh" {
  vpc_id      = var.VPC_ID
  name        = "allow-ssh-${var.ENV}"
  description = "security group that allows ssh and all egress traffic"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name         = "allow-ssh"
    Environmnent = var.ENV
  }
}