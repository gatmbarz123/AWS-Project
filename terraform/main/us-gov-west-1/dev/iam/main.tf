module "service_account" {
  source = "../../../../modules/management/irsa"

  policy_folder = var.policy_irsa_path

  for_each = {
    for pair in local.cluster_service_accounts : "${pair.cluster_name}.${pair.sa_name}" => {
      cluster_name         = pair.cluster_name
      name                 = "${pair.cluster_name}-${pair.sa_name}"
      service_account_path = lookup(pair.sa_config, "service_account_path", null)
      inline_policies      = lookup(pair.sa_config, "inline_policies", [])
      managed_policies     = lookup(pair.sa_config, "managed_policies", [])
      create_pod_identity  = lookup(pair.sa_config, "create_pod_identity", false)
      namespace            = lookup(pair.sa_config, "namespace", null)
      service_account_name = lookup(pair.sa_config, "service_account_name", null)
      assume_role_policy   = lookup(pair.sa_config, "assume_role_policy", null)
    }
  }

  cluster_name         = each.value.cluster_name
  name                 = each.value.name
  assume_role_policy   = each.value.assume_role_policy
  service_account_path = each.value.service_account_path
  inline_policies      = each.value.inline_policies
  managed_policies     = each.value.managed_policies
  create_pod_identity  = each.value.create_pod_identity
  namespace            = each.value.namespace
  service_account_name = each.value.service_account_name
}

module "iam_roles" {
  source = "../../../../modules/management/iam/role"

  prefix = var.prefix

  for_each           = local.iam_roles
  name               = each.key
  assume_role_policy = each.value.assume_role_policy
  tags               = var.tags
}

module "s3_user" {
  source = "../../../../modules/management/iam/users"

  user_name = "s3_user"
  tags      = var.tags

  policy_arns = [
    "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonSESFullAccess",
  ]

  inline_policies = {
    "app-projects-readwrite" = templatefile("${var.policy_applications_path}/app_projects_readwrite_policy.json.tpl", {
      SHORT_REGION      = var.short_region
      SHORT_ENVIRONMENT = var.short_environment
      PARTITION         = data.aws_partition.current.partition
    }),
    "read-sqs-queue-for-s3-events" = file("${var.policy_applications_path}/sqs_access_policy.json.tpl")
  }
}

module "s3_user_api" {
  source = "../../../../modules/management/iam/users"

  user_name = "s3_user_api"
  tags      = var.tags

  policy_arns = [
    "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonSESFullAccess",
  ]

  inline_policies = {
    "app-projects-api-readwrite" = templatefile("${var.policy_applications_path}/app_projects_api_readwrite_policy.json.tpl", {
      SHORT_REGION      = var.short_region
      SHORT_ENVIRONMENT = var.short_environment
      PARTITION         = data.aws_partition.current.partition
    }),
    "read-sqs-queue-for-s3-events" = file("${var.policy_applications_path}/sqs_access_policy.json.tpl")
  }
}

module "s3_python_user" {
  source = "../../../../modules/management/iam/users"

  user_name = "s3_python_user"
  tags      = var.tags

  inline_policies = {
    "app-projects-readwrite" = templatefile("${var.policy_applications_path}/app_projects_readwrite_policy.json.tpl", {
      SHORT_REGION      = var.short_region
      SHORT_ENVIRONMENT = var.short_environment
      PARTITION         = data.aws_partition.current.partition
    })
  }
}