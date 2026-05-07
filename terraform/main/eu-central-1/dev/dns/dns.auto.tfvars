private_hosted_zone_name             = "dev.euc1.example.com"
public_hosted_zone_name              = "example.com"
public_acm_domain_name               = "*.dev.euc1.example.com"
public_acm_subject_alternative_names = ["*.qa.euc1.example.com"]

private_hosted_zone_ids = ["Z0000000000000", "Z0000000000000"] # prod-euc1, staging

management_account_id = "123456789012"
management_role_name  = "mng-euc1-for-dev-account-route53-access"
