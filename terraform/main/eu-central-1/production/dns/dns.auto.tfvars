private_hosted_zone_name             = "prod.euc1.example.com"
public_hosted_zone_name              = "example.com"
public_acm_domain_name               = "*.euc1.example.com"
public_acm_subject_alternative_names = ["*.prod.euc1.example.com"]

dev_vpc_id = "vpc-029869d907f7da256"

management_account_id = "123456789012"
management_role_name  = "mng-euc1-for-prod-account-route53-access"