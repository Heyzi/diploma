terraform {
  backend "s3" {
    bucket  = "dev-035604165710"
    key     = "dev-terraform-aws-eks-workshop.tfstate"
    region  = "eu-central-1"
    encrypt = true
  }
}
