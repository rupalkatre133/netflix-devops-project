module "eks" {

  source  = "terraform-aws-modules/eks/aws"

  version = "~> 20.0"

  cluster_name = var.cluster_name

  cluster_version = "1.31"

  subnet_ids = module.vpc.private_subnets

  vpc_id = module.vpc.vpc_id

  eks_managed_node_groups = {

    default = {

      desired_size = 1
      max_size     = 1
      min_size     = 1

      instance_types = ["t2.micro"]
    }
  }

  enable_cluster_creator_admin_permissions = true
}
