locals {
  iam_roles = {
    "for-prod-account-route53-access" = {
      assume_role_policy = templatefile("${var.policy_path}/cross_account_trust_relationship_policy.json.tpl", {
        ACCOUNT_ID = var.production_account_id
      })
    }
  }

  iam_inline_policies = {
    "for-prod-account-route53-access" = {
      policy_file = templatefile("${var.policy_path}/route53_access_policy.json.tpl", {
        HOSTED_ZONE_ID = data.aws_route53_zone.public.zone_id
      })
    }
  }
}
