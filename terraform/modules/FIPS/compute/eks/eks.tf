module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0" # https://github.com/terraform-aws-modules/terraform-aws-eks/releases/tag/v20.14.0

  # General
  create                                 = true
  cluster_name                           = "${var.prefix}-eks"
  cluster_version                        = var.cluster_version
  create_kms_key                         = true
  kms_key_enable_default_policy          = true
  authentication_mode                    = "API"
  create_cloudwatch_log_group            = var.create_cloudwatch_log_group
  cluster_enabled_log_types              = var.cluster_enabled_log_types
  cloudwatch_log_group_retention_in_days = var.cloudwatch_log_group_retention_in_days
  cloudwatch_log_group_class             = var.cloudwatch_log_group_class

  cluster_encryption_config = {
    resources = ["secrets"]
  }

  node_security_group_tags = {
    "karpenter.sh/discovery" = "${var.prefix}-eks"
  }

  # AWS Access Entries
  enable_cluster_creator_admin_permissions = false

  access_entries = var.access_entries


  # Network Settings
  vpc_id                          = var.vpc_id
  subnet_ids                      = var.subnet_ids
  cluster_endpoint_private_access = var.cluster_endpoint_private_access
  cluster_endpoint_public_access  = var.cluster_endpoint_public_access



  # Cluster Security rules
  cluster_security_group_additional_rules = merge(
    {
      # Default VPC access rule
      eks_cluster = {
        description = "VPC only access"
        protocol    = "tcp"
        from_port   = 443
        to_port     = 443
        type        = "ingress"
        cidr_blocks = [var.vpc_cidr_block]
      }
    },
    {
      eks_outbound = {
        description = "EKS outbound"
        protocol    = "-1"
        from_port   = 0
        to_port     = 0
        type        = "egress"
        cidr_blocks = ["0.0.0.0/0"]
      }
    },
    var.additional_cluster_security_group_rules
  )

  # Nodes Security rules

  # Ingress
  node_security_group_additional_rules = {
    http = {
      description = "HTTP Node to node, clusterIP"
      protocol    = "tcp"
      from_port   = 80
      to_port     = 80
      type        = "ingress"
      self        = true
    },
    all_traffic = {
      description = "All traffic"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    },
    datadog_admission_controller = {
      description              = "Datadog admission controller"
      protocol                 = "tcp"
      from_port                = 8000
      to_port                  = 8000
      type                     = "ingress"
      source_security_group_id = module.eks.cluster_security_group_id
    }
  }

  # EKS Managed Node Group(s)
  eks_managed_node_groups = {
    karpenter = {
      name           = "karpenter"
      ami_type       = "AL2023_x86_64_STANDARD"
      subnet_ids     = [var.subnet_ids[0]]
      disk_size      = var.node_group_disk_size
      min_size       = var.node_group_min_size
      max_size       = var.node_group_max_size
      desired_size   = var.node_group_desired_size
      instance_types = var.node_group_instance_types
      capacity_type  = var.node_group_capacity_type

      cloudinit_post_nodeadm = [
        {
          content_type = "text/x-shellscript"
          content      = <<-EOT
            #!/bin/bash
            echo "FIPS post-nodeadm $(date)"
            dnf update -y
            dnf -y install crypto-policies crypto-policies-scripts
            fips-mode-setup --enable
            reboot
          EOT
        }
      ]

      block_device_mappings = {
        xvda = {
          device_name = "/dev/xvda"
          ebs = {
            volume_size           = var.node_group_disk_size
            volume_type           = "gp3"
            delete_on_termination = true
            encrypted             = true
          }
        }
      }

      create_launch_template         = true
      use_custom_launch_template     = true
      use_latest_ami_release_version = var.use_latest_ami_release_version
      release_version                = var.node_group_release_version
      enable_bootstrap_user_data     = true

      launch_template_tags = {
        UserDataVersion = "fips-2025-09-25-01"
      }
      labels = {
        role = "karpenter"
      }
      taints = {
        dedicated_no_schedule = {
          key    = "role"
          value  = "karpenter"
          effect = "NO_SCHEDULE"
        }
      }

      tags = merge(tomap({ "karpenter.sh/discovery" = "${var.prefix}-eks" }), var.tags)
    }
  }

  # EKS Addons
  cluster_addons = {
    coredns = {
      preserve    = true
      most_recent = true
      configuration_values = jsonencode({
        tolerations = [{
          operator = "Exists"
        }]
        nodeSelector = {
          "kubernetes.io/os" = "linux"
        }
        affinity = {
          nodeAffinity = {
            requiredDuringSchedulingIgnoredDuringExecution = {
              nodeSelectorTerms = [{
                matchExpressions = [{
                  key      = "nvidia.com/gpu"
                  operator = "NotIn"
                  values   = ["true"]
                }]
              }]
            }
          }
        }
      })
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
    eks-pod-identity-agent = {
      most_recent = true
    }
  }

  tags = var.tags
}