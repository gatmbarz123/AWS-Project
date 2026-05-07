cluster_version = "1.31"

eks = {
  "web" = {
    access_entries = {
      admins = {
        kubernetes_groups = []
        principal_arn     = "arn:aws:iam::123456789012:role/aws-reserved/sso.amazonaws.com/eu-central-1/AWSReservedSSO_admins_EXAMPLE"

        policy_associations = {
          all = {
            policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
            access_scope = {
              type = "cluster"
            }
          }
        }
      },
      github_user = {
        kubernetes_groups = []
        principal_arn     = "arn:aws:iam::123456789012:user/github_user"

        policy_associations = {
          all = {
            policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
            access_scope = {
              type = "cluster"
            }
          }
        }
      }
    }
    # Node Group - Karpenter
    node_group_ami_type       = "AL2023"
    node_group_disk_size      = 20
    node_group_min_size       = 1
    node_group_max_size       = 1
    node_group_desired_size   = 1
    node_group_instance_types = ["m6i.large"]
    node_group_capacity_type  = "ON_DEMAND"
  }
  "ai-non-gpu" = {
    access_entries = {
      admins = {
        kubernetes_groups = []
        principal_arn     = "arn:aws:iam::123456789012:role/aws-reserved/sso.amazonaws.com/eu-central-1/AWSReservedSSO_admins_EXAMPLE"

        policy_associations = {
          all = {
            policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
            access_scope = {
              type = "cluster"
            }
          }
        }
      },
      github_user = {
        kubernetes_groups = []
        principal_arn     = "arn:aws:iam::123456789012:user/github_user"

        policy_associations = {
          all = {
            policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
            access_scope = {
              type = "cluster"
            }
          }
        }
      },
      argocd-deployer = {
        kubernetes_groups = []
        principal_arn     = "arn:aws:iam::123456789012:role/qa-euc1-ai-non-gpu-eks-argocd-deployer"

        policy_associations = {
          all = {
            policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
            access_scope = {
              type = "cluster"
            }
          }
        }
      }
    }
    # Node Group - Karpenter
    node_group_ami_type       = "AL2023"
    node_group_disk_size      = 20
    node_group_min_size       = 1
    node_group_max_size       = 1
    node_group_desired_size   = 1
    node_group_instance_types = ["m6i.large"]
    node_group_capacity_type  = "ON_DEMAND"
  }
  "ai-gpu" = {
    access_entries = {
      admins = {
        kubernetes_groups = []
        principal_arn     = "arn:aws:iam::123456789012:role/aws-reserved/sso.amazonaws.com/eu-central-1/AWSReservedSSO_admins_EXAMPLE"

        policy_associations = {
          all = {
            policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
            access_scope = {
              type = "cluster"
            }
          }
        }
      },
      github_user = {
        kubernetes_groups = []
        principal_arn     = "arn:aws:iam::123456789012:user/github_user"

        policy_associations = {
          all = {
            policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
            access_scope = {
              type = "cluster"
            }
          }
        }
      },
      argocd-deployer = {
        kubernetes_groups = []
        principal_arn     = "arn:aws:iam::123456789012:role/qa-euc1-ai-gpu-eks-argocd-deployer"

        policy_associations = {
          all = {
            policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
            access_scope = {
              type = "cluster"
            }
          }
        }
      }
    }
    # Node Group - Karpenter
    node_group_ami_type       = "AL2023"
    node_group_disk_size      = 20
    node_group_min_size       = 1
    node_group_max_size       = 1
    node_group_desired_size   = 1
    node_group_instance_types = ["m6i.large"]
    node_group_capacity_type  = "ON_DEMAND"
  }
}