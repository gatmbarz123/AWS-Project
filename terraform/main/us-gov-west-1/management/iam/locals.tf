locals {
  iam_roles = {
    "for-dev-account-route53-access" = {
      assume_role_policy = templatefile("${var.policy_path}/cross_account_trust_relationship_policy.json.tpl",
        {
          ACCOUNT_ID = var.dev_account_id
          PARTITION  = data.aws_partition.current.partition
      })
    }
    "for-prod-account-route53-access" = {
      assume_role_policy = templatefile("${var.policy_path}/cross_account_trust_relationship_policy.json.tpl",
        {
          ACCOUNT_ID = var.production_account_id
          PARTITION  = data.aws_partition.current.partition
      })
    }
    "backup-rds-dev" = {
      assume_role_policy = templatefile("${var.policy_path}/backup_rds_dev_policy.json.tpl",
        {
          ACCOUNT_ID = var.dev_account_id
          PARTITION  = data.aws_partition.current.partition
      })
    }
    "backup-rds-prod" = {
      assume_role_policy = templatefile("${var.policy_path}/backup_rds_dev_policy.json.tpl",
        {
          ACCOUNT_ID = var.production_account_id
          PARTITION  = data.aws_partition.current.partition
      })
    }
  }

  iam_inline_policies = {
    "for-dev-account-route53-access" = {
      policy_file = templatefile("${var.policy_path}/route53_access_policy.json.tpl",
        {
          HOSTED_ZONE_ID = data.aws_route53_zone.public.zone_id
          PARTITION      = data.aws_partition.current.partition
      })
    }
    "for-prod-account-route53-access" = {
      policy_file = templatefile("${var.policy_path}/route53_access_policy.json.tpl",
        {
          HOSTED_ZONE_ID = data.aws_route53_zone.public.zone_id
          PARTITION      = data.aws_partition.current.partition
      })
    }
    "backup-rds-dev" = {
      policy_file = templatefile("${var.policy_path}/backup_service_access_policy.json.tpl", {
        PARTITION = data.aws_partition.current.partition
      })
    }
    "backup-rds-prod" = {
      policy_file = templatefile("${var.policy_path}/backup_service_access_policy.json.tpl", {
        PARTITION = data.aws_partition.current.partition
      })
    }
  }
}
