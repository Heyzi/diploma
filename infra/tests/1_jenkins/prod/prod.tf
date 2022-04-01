module "default-vpc" {
  source           = "../modules/vpc"
  ENV              = var.ENV
  CIDR_BLOCK       = var.CIDR_BLOCK
}

module "instance" {
  source         = "../modules/instance"
  ENV            = var.ENV
  VPC_ID         = module.default-vpc.vpc_id
  PUB_KEY        = var.PUB_KEY
  INSTANCE_TYPE  = var.INSTANCE_TYPE
  EGRESS_RULES   = var.EGRESS_RULES
  INGRESS_RULES  = var.INGRESS_RULES
  SUBNET_ID      = module.network.subnet_id
}

module "network" {
  source         = "../modules/network"
  ENV            = var.ENV
  VPC_ID         = module.default-vpc.vpc_id
  DEF_RT         = module.default-vpc.default_rt_id
  AZ             = var.AZ
  CIDR_BLOCK     = var.CIDR_BLOCK

}
