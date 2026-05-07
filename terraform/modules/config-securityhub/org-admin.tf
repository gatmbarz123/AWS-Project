# Org-level Security Hub and Config aggregation (management account only)

resource "aws_securityhub_organization_admin_account" "_" {
  count            = var.is_management_account ? 1 : 0
  admin_account_id = var.account_id
}

resource "aws_securityhub_organization_configuration" "_" {
  count       = var.is_management_account ? 1 : 0
  auto_enable = true
  depends_on  = [aws_securityhub_organization_admin_account._]
}

resource "aws_config_configuration_aggregator" "org" {
  count = var.is_management_account ? 1 : 0
  name  = "org-aggregator"
  account_aggregation_source {
    account_ids = var.member_account_ids
    all_regions = true
  }
}