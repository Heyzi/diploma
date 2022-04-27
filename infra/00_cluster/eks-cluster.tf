module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version          = "~> 18.0"
  cluster_name    = var.project_name
  cluster_version = "1.22"
  vpc_id           = module.vpc.vpc_id
  subnet_ids       = module.vpc.private_subnets

  eks_managed_node_group_defaults = {
    disk_size      = 10
    instance_types = ["t3.medium", "t3.small"]
    enable_monitoring       = true

  }

  eks_managed_node_groups = {

    diploma-node-group = {
      min_size     = 1
      max_size     = 3
      desired_size = 2

      instance_types = ["t3.medium"]
      capacity_type  = "SPOT"
      enable_monitoring       = true

    }
  }
 cluster_security_group_additional_rules = {
    egress_nodes_ephemeral_ports_tcp = {
      description                = "To node 1025-65535"
      protocol                   = "tcp"
      from_port                  = 1025
      to_port                    = 65535
      type                       = "egress"
      source_node_security_group = true
    }
  }

  # Extend node-to-node security group rules
  node_security_group_additional_rules = {
    ingress_self_all = {
      description = "Node to node all ports/protocols"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }
    egress_all = {
      description      = "Node all egress"
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      type             = "egress"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}
