module "iam_roles" {
  source = "../../../../modules/management/iam/role"

  prefix = var.prefix

  for_each           = local.iam_roles
  name               = each.key
  assume_role_policy = each.value.assume_role_policy
  tags               = var.tags
}

module "iam_inline_policies" {
  source = "../../../../modules/management/iam/inline-policy"

  for_each    = local.iam_inline_policies
  name        = each.key
  role_name   = module.iam_roles[each.key].name
  policy_file = each.value.policy_file
}