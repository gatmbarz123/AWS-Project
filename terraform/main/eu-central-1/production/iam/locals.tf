locals {
  clusters = [
    "${var.prefix}-web-eks",
    "${var.prefix}-python-ai-eks"
  ]

  service_accounts = {
    # ArgoCD
    argocd-manager = {
      clusters = ["${var.prefix}-web-eks"],
      assume_role_policy = templatefile("${var.policy_irsa_path}/argocd_sa_trust_relationship_policy.json.tpl",
        {
          ACCOUNT_ID        = var.aws_account_id
          EKS_OIDC_PROVIDER = replace(data.aws_eks_cluster.web.identity[0].oidc[0].issuer, "https://", "")
          PARTITION         = data.aws_partition.current.partition
        }
      )
      inline_policies = [
        file("${var.policy_irsa_path}/argocd_role_policy.json.tpl")
      ]
    }

    # Cluster Addons
    private-eks-external-dns = {
      clusters             = local.clusters,
      service_account_path = "system:serviceaccount:external-dns:private-eks-external-dns-sa"
      inline_policies = [
        templatefile("${var.policy_iam_path}/route53_access_policy.json.tpl",
          {
            HOSTED_ZONE_ID = data.aws_route53_zone.private.zone_id
            PARTITION      = data.aws_partition.current.partition
          }
        )
      ]
    }
    public-eks-external-dns = {
      clusters             = local.clusters,
      service_account_path = "system:serviceaccount:external-dns:public-eks-external-dns-sa"
      inline_policies = [
        templatefile("${var.policy_iam_path}/cross_account_assume_role_policy.json.tpl",
          {
            ACCOUNT_ID = var.management_account_id
            ROLE_NAME  = "mng-euc1-for-${var.short_environment}-account-route53-access"
            PARTITION  = data.aws_partition.current.partition
          }
        )
      ]
    }
    aws-load-balancer-controller = {
      clusters             = local.clusters,
      service_account_path = "system:serviceaccount:aws-lb-controller:aws-load-balancer-controller-sa"
      inline_policies = [
        templatefile("${var.policy_iam_path}/aws_load_balancer_controller_policy.json.tpl", {
          PARTITION = data.aws_partition.current.partition
        })
      ]
    }

    # Applications
    applications-secretstore = {
      clusters             = setsubtract(local.clusters, ["${var.prefix}-python-ai-eks"]),
      service_account_path = "system:serviceaccount:${var.short_environment}:applications-secretstore-sa"
      inline_policies = [
        templatefile("${var.policy_applications_path}/applications_secretstore_policy.json.tpl",
          {
            REGION     = var.region
            ACCOUNT_ID = var.aws_account_id
            PARTITION  = data.aws_partition.current.partition
          }
        )
      ]
    }

    applications-secretstore-es = {
      clusters             = local.clusters,
      service_account_path = "system:serviceaccount:external-secrets:applications-secretstore-sa"
      inline_policies = [
        templatefile("${var.policy_applications_path}/applications_secretstore_policy.json.tpl",
          {
            REGION     = var.region
            ACCOUNT_ID = var.aws_account_id
            PARTITION  = data.aws_partition.current.partition
          }
        )
      ]
    }

    web = {
      clusters             = ["${var.prefix}-web-eks"],
      service_account_path = "system:serviceaccount:${var.short_environment}:web-sa"
      inline_policies = [
        templatefile("${var.policy_applications_path}/web_app_policy.json.tpl",
          {
            SHORT_REGION      = var.short_region
            SHORT_ENVIRONMENT = var.short_environment
            BUCKET_NAME       = "example-projects"
            PARTITION         = data.aws_partition.current.partition
          }
        )
      ]
    }
    web-api = {
      clusters             = ["${var.prefix}-web-eks"],
      service_account_path = "system:serviceaccount:web-api:web-api-sa"
      inline_policies = [
        templatefile("${var.policy_applications_path}/web_app_policy.json.tpl",
          {
            SHORT_REGION      = var.short_region
            SHORT_ENVIRONMENT = var.short_environment
            BUCKET_NAME       = "example-projects-api"
            PARTITION         = data.aws_partition.current.partition
          }
        )
      ]
    }
    datadog = {
      clusters             = local.clusters,
      service_account_path = "system:serviceaccount:datadog:datadog-secretstore-sa"
      inline_policies = [
        templatefile("${var.policy_applications_path}/datadog_secretstore_policy.json.tpl",
          {
            REGION     = var.region
            ACCOUNT_ID = var.aws_account_id
            PARTITION  = data.aws_partition.current.partition
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
    python-ai-eks-argocd-deployer = {
      assume_role_policy = templatefile("${var.policy_irsa_path}/argocd_deployer_trust_relationship_policy.json.tpl",
        {
          ACCOUNT_ID = var.aws_account_id
          ROLE_NAME  = "${var.prefix}-web-eks-argocd-manager"
          PARTITION  = data.aws_partition.current.partition
        }
      )
    }
  }
}
