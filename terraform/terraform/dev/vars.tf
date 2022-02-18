variable "ENV" {
  default = "development"
}

variable "INST_COUNT" {
  default = "2"
}

variable "INST_TYPE" {
  default = "t2.nano"
}

variable "AWS_REGION" {
  default = "eu-west-1"
}

variable "OWNER" {
  type    = string
  default = "PlatonovAA"
}

variable "PRIVATE_KEY_PATH" {
  default = "~/.ssh/id_rsa"
}

variable "PUBLIC_KEY_PATH" {
  default = "~/.ssh/id_rsa.pub"
}

variable "EC2_USER" {
  default = "ec2-user"
}

variable "AMI" {
  default = "ami-0bf84c42e04519c85"
}

variable "SUBNETS" {
  type    = list
  default = ["10.100.2.0/24", "10.100.3.0/24"]
}
