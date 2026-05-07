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

# Temporary: grants dev external-dns access to example-app.example.com public zone
# Remove when VPN is set up and dev reverts to internal-only
resource "aws_iam_role_policy" "dev_example-app_route53" {
  name = "example-app-public-zone-access"
  role = module.iam_roles["for-dev-account-route53-access"].name

  policy = templatefile("${var.policy_path}/route53_access_policy.json.tpl",
    {
      HOSTED_ZONE_ID = "Z0000000000000"
      PARTITION      = data.aws_partition.current.partition
    }
  )
}

# Temporary: grants dev external-dns access to usgw1.example.com public zone
# Remove when VPN is set up and dev reverts to internal-only
resource "aws_iam_role_policy" "dev_usgw1_route53" {
  name = "usgw1-public-zone-access"
  role = module.iam_roles["for-dev-account-route53-access"].name

  policy = templatefile("${var.policy_path}/route53_access_policy.json.tpl",
    {
      HOSTED_ZONE_ID = "Z0000000000000"
      PARTITION      = data.aws_partition.current.partition
    }
  )
}