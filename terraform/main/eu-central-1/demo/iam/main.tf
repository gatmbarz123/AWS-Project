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