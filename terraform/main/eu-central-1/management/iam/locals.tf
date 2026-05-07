locals {
  iam_roles = {
    "for-dev-account-route53-access" = {
      assume_role_policy = templatefile("${var.policy_path}/cross_account_trust_relationship_policy.json.tpl",
        {
          ACCOUNT_ID = var.dev_account_id
      })
    }
    "for-prod-account-route53-access" = {
      assume_role_policy = templatefile("${var.policy_path}/cross_account_trust_relationship_policy.json.tpl",
        {
          ACCOUNT_ID = var.production_account_id
      })
    }
    "for-stg-account-route53-access" = {
      assume_role_policy = templatefile("${var.policy_path}/cross_account_trust_relationship_policy.json.tpl",
        {
          ACCOUNT_ID = var.staging_account_id
      })
    }
    "for-demo-account-route53-access" = {
      assume_role_policy = templatefile("${var.policy_path}/cross_account_trust_relationship_policy.json.tpl",
        {
          ACCOUNT_ID = var.demo_account_id
      })
    }
    "backup-rds-dev" = {
      assume_role_policy = templatefile("${var.policy_path}/backup_rds_dev_policy.json.tpl",
        {
          ACCOUNT_ID = var.dev_account_id
      })
    }
    "backup-rds-prod" = {
      assume_role_policy = templatefile("${var.policy_path}/backup_rds_dev_policy.json.tpl",
        {
          ACCOUNT_ID = var.production_account_id
      })
    }
    "backup-rds-stg" = {
      assume_role_policy = templatefile("${var.policy_path}/backup_rds_dev_policy.json.tpl",
        {
          ACCOUNT_ID = var.staging_account_id
      })
    }
    "backup-rds-demo" = {
      assume_role_policy = templatefile("${var.policy_path}/backup_rds_dev_policy.json.tpl",
        {
          ACCOUNT_ID = var.demo_account_id
      })
    }
  }

  iam_inline_policies = {
    "for-dev-account-route53-access" = {
      policy_file = templatefile("${var.policy_path}/route53_access_policy.json.tpl",
        {
          HOSTED_ZONE_ID = data.aws_route53_zone.public.zone_id
      })
    }
    "for-prod-account-route53-access" = {
      policy_file = templatefile("${var.policy_path}/route53_access_policy.json.tpl",
        {
          HOSTED_ZONE_ID = data.aws_route53_zone.public.zone_id
      })
    }
    "for-stg-account-route53-access" = {
      policy_file = templatefile("${var.policy_path}/route53_access_policy.json.tpl",
        {
          HOSTED_ZONE_ID = data.aws_route53_zone.public.zone_id
      })
    }
    "for-demo-account-route53-access" = {
      policy_file = templatefile("${var.policy_path}/route53_access_policy.json.tpl",
        {
          HOSTED_ZONE_ID = data.aws_route53_zone.public.zone_id
      })
    }
    "backup-rds-dev" = {
      policy_file = file("${var.policy_path}/backup_service_access_policy.json.tpl")
    }
    "backup-rds-prod" = {
      policy_file = file("${var.policy_path}/backup_service_access_policy.json.tpl")
    }
    "backup-rds-stg" = {
      policy_file = file("${var.policy_path}/backup_service_access_policy.json.tpl")
    }
    "backup-rds-demo" = {
      policy_file = file("${var.policy_path}/backup_service_access_policy.json.tpl")
    }
  }
}