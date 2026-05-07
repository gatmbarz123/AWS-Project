module "secrets" {
  source = "../../../../modules/compute/secrets"

  for_each = toset(local.secret_name_prefixes)

  partition          = data.aws_partition.current.partition
  region             = data.aws_region.current.name
  prefix             = var.prefix
  secret_name_prefix = each.value
  short_environment  = var.short_environment
  short_region       = var.short_region
  tags               = var.tags
}
