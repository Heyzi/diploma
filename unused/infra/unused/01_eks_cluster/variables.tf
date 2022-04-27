# variable "aws_access_key" {
#   description = "AWS access key"
#   type        = string
# }

# variable "aws_secret_key" {
#   description = "AWS secret key"
#   type        = string
# }

variable "region" {
  description = "The aws region. https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html"
  type        = string
}

variable "availability_zones_count" {
  description = "The number of AZs."
  type        = number
}

variable "project_name" {
  description = "Name of the project deployment."
  type        = string
}

variable "env" {
  description = "Env"
  type        = string
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden"
  type        = string
}

variable "subnet_cidr_bits" {
  description = "The number of subnet bits for the CIDR. For example, specifying a value 8 for this parameter will create a CIDR with a mask of /24."
  type        = number
  default     = 8
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default = {
    "Project"     = "epam-diploma"
    "Environment" = "Development"
    "Owner"       = "Platonov A.A."
  }
}