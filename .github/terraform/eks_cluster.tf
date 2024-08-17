
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "sockshop-cluster"
  cluster_version = "1.30"

  cluster_endpoint_public_access  = true
  
  vpc_id                   = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  
  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    instance_types = ["t2.medium"]
    
  }

  eks_managed_node_groups = {
    node1 = {
      # Starting on 1.30, AL2 is the default AMI type for EKS managed node groups
      ami_type       = "AL2_x86_64"
      instance_types = ["t2.medium"]

      min_size     = 1
      max_size     = 2
      desired_size = 2
    }

     node2 = {
      # Starting on 1.30, AL2 is the default AMI type for EKS managed node groups
      ami_type       = "AL2_x86_64"
      instance_types = ["t2.medium"]

      min_size     = 1
      max_size     = 2
      desired_size = 2
    }
  }

  # Cluster access entry
  # To add the current caller identity as an administrator
  enable_cluster_creator_admin_permissions = true

}