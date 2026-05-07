locals {
  clusters = [
    "${var.prefix}-web-eks",
    "${var.prefix}-ai-gpu-eks",
    "${var.prefix}-ai-non-gpu-eks"
  ]

  service_accounts = {
    # ArgoCD
    argocd-manager = {
      clusters = ["${var.prefix}-web-eks"],
      assume_role_policy = templatefile("${var.policy_path}/argocd_trust_relationship_policy.json.tpl",
        {
          ACCOUNT_ID        = var.aws_account_id
          EKS_OIDC_PROVIDER = replace(data.aws_eks_cluster.web.identity[0].oidc[0].issuer, "https://", "")
        }
      )
      inline_policies = [
        file("${var.policy_path}/argocd_role_policy.json.tpl")
      ]
    }

    # Cluster Addons
    private-eks-external-dns = {
      clusters             = local.clusters,
      service_account_path = "system:serviceaccount:external-dns:private-eks-external-dns-sa"
      inline_policies = [
        templatefile("${var.policy_path}/private_external_dns_policy.json.tpl",
          {
            HOSTED_ZONE_ID = data.aws_route53_zone.private.zone_id
          }
        )
      ]
    }
    public-eks-external-dns = {
      clusters             = local.clusters,
      service_account_path = "system:serviceaccount:external-dns:public-eks-external-dns-sa"
      inline_policies = [
        templatefile("${var.policy_path}/public_external_dns_policy.json.tpl",
          {
            REGION     = var.region
            ACCOUNT_ID = var.aws_account_id
          }
        )
      ]
    }
    aws-load-balancer-controller = {
      clusters             = local.clusters,
      service_account_path = "system:serviceaccount:aws-lb-controller:aws-load-balancer-controller-sa"
      inline_policies = [
        file("${var.policy_path}/aws_load_balancer_controller_policy.json.tpl")
      ]
    }

    # Applications
    applications-secretstore = {
      clusters             = local.clusters,
      service_account_path = "system:serviceaccount:${var.short_environment}:applications-secretstore-sa"
      inline_policies = [
        templatefile("${var.policy_path}/applications_secretstore_policy.json.tpl",
          {
            REGION     = var.region
            ACCOUNT_ID = var.aws_account_id
          }
        )
      ]
    }
  }

  # Modified flattened list to respect cluster specifications
  cluster_service_accounts = flatten([
    for sa_name, sa_config in local.service_accounts : [
      for cluster_name in sa_config.clusters : {
        cluster_name = cluster_name
        sa_name      = sa_name
        sa_config    = sa_config
      }
    ]
  ])


  iam_roles = {
    ai-gpu-eks-argocd-deployer = {
      assume_role_policy = templatefile("${var.policy_path}/argocd_assume_role_policy.json.tpl",
        {
          ACCOUNT_ID = var.aws_account_id
          ROLE_NAME  = "${var.prefix}-web-eks-argocd-manager"
        }
      )
    }
    ai-non-gpu-eks-argocd-deployer = {
      assume_role_policy = templatefile("${var.policy_path}/argocd_assume_role_policy.json.tpl",
        {
          ACCOUNT_ID = var.aws_account_id
          ROLE_NAME  = "${var.prefix}-web-eks-argocd-manager"
        }
      )
    }
  }
}

