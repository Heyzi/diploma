#IGW
resource "aws_internet_gateway" "my-dev-igw" {
    vpc_id = "${aws_vpc.my-dev-vpc.id}"

    tags = {
        Name  = "${var.ENV}-igw"
        Owner = "${var.OWNER}"
    }
}

#route to inet
resource "aws_route_table" "my-dev-route" {
    vpc_id = "${aws_vpc.my-dev-vpc.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.my-dev-igw.id}"
    }

    tags = {
        Name  = "${var.ENV}-rt"
        Owner = "${var.OWNER}"
    }
}

# add route to subnet
resource "aws_route_table_association" "my-dev-ass-to-sub" {
    count     = 2
    subnet_id = "${aws_subnet.my-dev-subnet[count.index].id}"
    route_table_id = "${aws_route_table.my-dev-route.id}"
}

# security group
resource "aws_security_group" "my-dev-sg" {

    vpc_id = "${aws_vpc.my-dev-vpc.id}"

    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name  = "${var.ENV}-sg"
        Owner = "${var.OWNER}"
    }
}
