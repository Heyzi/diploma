variable "AWS_REGION" {
  default = "eu-central-1"
}
variable "CIDR_BLOCK" {
  default = "11.10.10.0/24"
}
variable "PUB_KEY" {
  type    = string
  default = "~/.ssh/id_rsa.pub"
}
variable "INSTANCE_TYPE" {
  type    = string
  default = "t2.micro"
}
variable "INGRESS_RULES" {
  type    = list(number)
  default = [22, 8080]
}
variable "EGRESS_RULES" {
  type    = list(number)
  default = [0]
}
variable "ENV" {
  type    = string
  default = "dev"
}
variable "AZ" {
  type    = string
  default = "eu-central-1a"
}
