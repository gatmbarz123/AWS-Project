module "sso_users" {
  source = "../../../../modules/management/sso/user"

  for_each     = var.sso_users
  display_name = each.key
  user_name    = each.value.user_name
  name = {
    given_name  = split("_", each.key)[0]
    family_name = split("_", each.key)[1]
  }
  emails = [
    {
      value = each.value.user_name
    }
  ]
}

module "sso_groups" {
  source = "../../../../modules/management/sso/group"

  for_each     = var.sso_groups
  display_name = each.value.display_name
  description  = each.value.description
}

module "sso_admins_group_memberships" {
  source = "../../../../modules/management/sso/group-membership"

  for_each  = toset(var.sso_group_memberships["admins"].member_id)
  group_id  = module.sso_groups["admins"].group_id
  member_id = module.sso_users[each.value].user_id
}

module "sso_algo_group_memberships" {
  source = "../../../../modules/management/sso/group-membership"

  for_each  = toset(var.sso_group_memberships["algo"].member_id)
  group_id  = module.sso_groups["algo"].group_id
  member_id = module.sso_users[each.value].user_id
}

module "sso_developers_group_memberships" {
  source = "../../../../modules/management/sso/group-membership"

  for_each  = toset(var.sso_group_memberships["developers"].member_id)
  group_id  = module.sso_groups["developers"].group_id
  member_id = module.sso_users[each.value].user_id
}

module "sso_developers_high_group_memberships" {
  source = "../../../../modules/management/sso/group-membership"

  for_each  = toset(var.sso_group_memberships["developers_high"].member_id)
  group_id  = module.sso_groups["developers_high"].group_id
  member_id = module.sso_users[each.value].user_id
}

module "sso_developers_high_plus_group_memberships" {
  source = "../../../../modules/management/sso/group-membership"

  for_each  = toset(var.sso_group_memberships["developers_high_plus"].member_id)
  group_id  = module.sso_groups["developers_high_plus"].group_id
  member_id = module.sso_users[each.value].user_id
}

module "sso_developers_basic_group_memberships" {
  source = "../../../../modules/management/sso/group-membership"

  for_each  = toset(var.sso_group_memberships["developers_basic"].member_id)
  group_id  = module.sso_groups["developers_basic"].group_id
  member_id = module.sso_users[each.value].user_id
}

module "permission_set" {
  source = "../../../../modules/management/sso/permission-set"

  for_each           = var.permission_sets
  name               = each.key
  description        = each.value.description
  inline_policy      = lookup(each.value, "inline_policy", null) != null ? file(each.value.inline_policy) : null
  managed_policy_arn = lookup(each.value, "managed_policy_arn", null)
  region             = lookup(each.value, "region", var.region)
}

module "account_assignment" {
  source = "../../../../modules/management/sso/account-assignment"

  for_each           = var.account_assignments
  sso_group_id       = module.sso_groups[each.value.sso_group_id].group_id
  account_id         = each.value.account_id
  permission_set_arn = module.permission_set[each.value.permission_set_name].arn
}

