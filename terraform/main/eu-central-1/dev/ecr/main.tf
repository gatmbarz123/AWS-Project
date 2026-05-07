module "ecr_mirror" {
  source = "github.com/buildecho/onboarding-providers.git//echo-terraform-ecr-mirror?ref=main"

  for_each = local.ecr_mirrors

  echo_registry_account_id = each.value.echo_registry_account_id
  echo_registry_region     = each.value.echo_registry_region
  cache_namespace          = each.value.cache_namespace
  role_name                = each.value.role_name
  policy_name              = each.value.policy_name

  tags = var.tags
}
