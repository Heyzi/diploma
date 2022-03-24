variable "REGION" {
  default     = "eu-west-1"
  description = "AWS region"
}

variable "ENV" {
  default = "dev"
}

variable "OWNER" {
  type    = string
  default = "PlatonovAA"
}