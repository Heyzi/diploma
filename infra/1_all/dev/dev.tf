locals {
  production_availability_zones = ["${var.AWS_REGION}a", "${var.AWS_REGION}b", "${var.AWS_REGION}c"]
}

module "default-vpc" {
  source           = "../modules/vpc"
  ENV              = var.ENV
  CIDR_BLOCK       = var.CIDR_BLOCK
}

module "network" {
  source         = "../modules/network"
  region               = var.AWS_REGION
  environment          = var.ENV


  # VPC_ID         = module.default-vpc.vpc_id
  # DEF_RT         = module.default-vpc.default_rt_id
  # AZ             = var.AZ
  # CIDR_BLOCK     = var.CIDR_BLOCK

}

module "Networking" {

  
  vpc_cidr             = var.vpc_cidr
  public_subnets_cidr  = var.public_subnets_cidr
  private_subnets_cidr = var.private_subnets_cidr
  availability_zones   = local.production_availability_zones

}
