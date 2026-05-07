private_hosted_zone_name             = "prod.use1.example.com"
public_hosted_zone_name              = "example.com"
public_acm_domain_name               = "*.use1.example.com"
public_acm_subject_alternative_names = ["*.prod.use1.example.com"]

management_account_id = "123456789012"
management_role_name  = "mng-use1-for-prod-account-route53-access"