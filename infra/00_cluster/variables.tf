variable "region" {
  default     = "eu-central-1"
  description = "AWS region"
}

variable "project_name" {
  description = "Project name"
  default     = "awesome-project"
  type        = string
}

# variable "db_password" {
#   description = "RDS root user password"
#   sensitive   = true
# }
