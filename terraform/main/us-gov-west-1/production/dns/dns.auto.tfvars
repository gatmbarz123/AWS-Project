private_hosted_zone_name             = "prod.usgw1.example.com"
public_hosted_zone_name              = "example.com"
public_acm_domain_name               = "*.usgw1.example.com"
public_acm_subject_alternative_names = ["*.prod.usgw1.example.com"]

dev_vpc_id = "vpc-09b1462e9ca79922c"

management_account_id = "123456789012"
management_role_name  = "mng-usgw1-for-prod-account-route53-access"
