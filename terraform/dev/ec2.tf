resource "aws_instance" "my-dev-instance" {
    count                  = "${var.INST_COUNT}"
    ami                    = "${var.AMI}"
    instance_type          = "${var.INST_TYPE}"
    subnet_id              = "${aws_subnet.my-dev-subnet[count.index].id}"
    vpc_security_group_ids = ["${aws_security_group.my-dev-sg.id}"]
    key_name               = "${aws_key_pair.my-dev-key-pair.id}"

    tags = {
        Name  = "${var.ENV}-instance-${count.index + 1}"
        Owner = "${var.OWNER}"
  }
# provisioner "remote-exec" {
#    inline = [
#      "apt-get -y install nginx",
#      "service nginx start",
#    ]
#  }
}

resource "aws_key_pair" "my-dev-key-pair" {
    key_name   = "my-dev-key-pair"
    public_key = "${file(var.PUBLIC_KEY_PATH)}"
}
