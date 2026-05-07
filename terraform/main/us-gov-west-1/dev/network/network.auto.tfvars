#  ----------------------------------------------------------------------------------------------------------
# VPC Configurations
vpc = {
  # Main VPC configuration (using the same values as above for backward compatibility)
  vpc = {
    cidr                         = "10.50.0.0/16"
    private_subnets              = ["10.50.0.0/22", "10.50.4.0/22", "10.50.8.0/22"]
    public_subnets               = ["10.50.12.0/22", "10.50.16.0/22", "10.50.20.0/22"]
    database_subnets             = ["10.50.24.0/22", "10.50.28.0/22", "10.50.32.0/22"]
    enable_nat_gateway           = true
    single_nat_gateway           = true
    one_nat_gateway_per_az       = false
    create_database_subnet_group = true
    private_subnet_tags = {
      "kubernetes.io/role/internal-elb"                = "1"
      "Tier"                                           = "private"
      "karpenter.sh/discovery/dev-usgw1-web-eks"       = "true"
      "karpenter.sh/discovery/dev-usgw1-python-ai-eks" = "true"
    }
    public_subnet_tags = {
      "kubernetes.io/role/elb" = "1"
      "Tier"                   = "public"
    }
    database_subnet_tags = {
      "Tier" = "database"
    }
  }

  # Windows VPC configuration (empty placeholders)
  vpc-windows = {
    cidr                         = "10.54.0.0/16"
    private_subnets              = ["10.54.0.0/22", "10.54.4.0/22", "10.54.8.0/22"]
    public_subnets               = ["10.54.12.0/22", "10.54.16.0/22", "10.54.20.0/22"]
    database_subnets             = ["10.54.24.0/22", "10.54.28.0/22", "10.54.32.0/22"]
    enable_nat_gateway           = true
    single_nat_gateway           = true
    one_nat_gateway_per_az       = false
    create_database_subnet_group = true
    private_subnet_tags = {
      "Tier" = "private"
    }
    public_subnet_tags = {
      "Tier" = "public"
    }
    database_subnet_tags = {
      "Tier" = "database"
    }
  }
}

# VPC Flow Logs
enable_flow_log                                 = true
create_flow_log_cloudwatch_log_group            = true
create_flow_log_cloudwatch_iam_role             = true
flow_log_max_aggregation_interval               = 600
flow_log_cloudwatch_log_group_retention_in_days = 30
flow_log_cloudwatch_log_group_class             = "INFREQUENT_ACCESS"




# Client VPN

# client_vpn_domain                         = ""
# client_vpn_saml_provider_arn              = "arn:aws:iam::123456789012:saml-provider/dev-usgw1-vpn-app"
# client_vpn_self_service_saml_provider_arn = "arn:aws:iam::123456789012:saml-provider/dev-usgw1-vpn-selfservice-app"
# client_vpn_cidr_block                     = "10.36.0.0/22"
# client_vpn_dns_servers                    = ["10.30.0.2"]
# client_vpn_split_tunnel                   = true
# sso_identity_groups                       = ["00000000-0000-0000-0000-000000000000"] # admins_group_id
