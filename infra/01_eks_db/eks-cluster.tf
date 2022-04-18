module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "18.24.0"
  cluster_name    = local.cluster_name
  cluster_version = "1.22"
  subnets         = module.vpc.private_subnets

  vpc_id = module.vpc.vpc_id

  workers_group_defaults = {
    root_volume_type = "gp2"
  }

  worker_groups = [
    {
      name                 = "epam-diploma-wg"
      instance_type        = "t2.medium"
      asg_desired_capacity = 2
      asg_max_size         = 4
      additional_security_group_ids = [aws_security_group.worker_group_mgmt.id]
      tags = [
        {
          "key"                 = "k8s.io/cluster-autoscaler/enabled"
          "propagate_at_launch" = "false"
          "value"               = "true"
        },
        {
          "key"                 = "k8s.io/cluster-autoscaler/my_eks"
          "propagate_at_launch" = "false"
          "value"               = "owned"
        }
      ]
    }
  ]
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}
