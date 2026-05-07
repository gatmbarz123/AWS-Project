# Network project will include VPC, VPC Endpoints and VPN

module "vpc" {
  source = "../../../../modules/network/vpc"

  prefix                       = var.prefix
  name                         = "vpc"
  cidr                         = var.vpc.vpc.cidr
  availability_zones           = ["${var.region}a", "${var.region}b", "${var.region}c"]
  private_subnets              = var.vpc.vpc.private_subnets
  public_subnets               = var.vpc.vpc.public_subnets
  database_subnets             = var.vpc.vpc.database_subnets
  enable_nat_gateway           = var.vpc.vpc.enable_nat_gateway
  single_nat_gateway           = var.vpc.vpc.single_nat_gateway
  one_nat_gateway_per_az       = var.vpc.vpc.one_nat_gateway_per_az
  create_database_subnet_group = var.vpc.vpc.create_database_subnet_group

  private_subnet_tags  = var.vpc.vpc.private_subnet_tags
  public_subnet_tags   = var.vpc.vpc.public_subnet_tags
  database_subnet_tags = var.vpc.vpc.database_subnet_tags

  # Flow Logs
  enable_flow_log                                 = var.enable_flow_log
  create_flow_log_cloudwatch_log_group            = var.create_flow_log_cloudwatch_log_group
  create_flow_log_cloudwatch_iam_role             = var.create_flow_log_cloudwatch_iam_role
  flow_log_max_aggregation_interval               = var.flow_log_max_aggregation_interval
  flow_log_cloudwatch_log_group_retention_in_days = var.flow_log_cloudwatch_log_group_retention_in_days
  flow_log_cloudwatch_log_group_class             = var.flow_log_cloudwatch_log_group_class
  tags                                            = var.tags
}

module "vpc_endpoints" {
  source = "../../../../modules/network/vpc-endpoints"

  prefix         = var.prefix
  vpc_id         = module.vpc.id
  vpc_cidr_block = var.vpc.vpc.cidr

  for_each                                       = local.vpc_endpoints
  service_name                                   = each.value.service_name
  subnet_ids                                     = lookup(each.value, "subnet_ids", module.vpc.private_subnets)
  ip_address_type                                = lookup(each.value, "ip_address_type", "ipv4")
  vpc_endpoint_type                              = lookup(each.value, "vpc_endpoint_type", "Interface")
  private_dns_enabled                            = lookup(each.value, "private_dns_enabled", true)
  private_dns_only_for_inbound_resolver_endpoint = lookup(each.value, "private_dns_only_for_inbound_resolver_endpoint", false)
  name                                           = each.key
  sg_ingress_rules                               = lookup(each.value, "sg_ingress_rules", {})

  tags = var.tags
}

# module "client-vpn" {
#   source = "../../../../modules/network/client-vpn"

#   # General
#   prefix = var.prefix

#   # ACM
#   client_vpn_domain = var.client_vpn_domain

#   # VPC Association
#   vpc_id            = module.vpc.id
#   availability_zone = "${var.region}a"

#   # SAML Providers
#   saml_provider_arn              = var.client_vpn_saml_provider_arn
#   self_service_saml_provider_arn = var.client_vpn_self_service_saml_provider_arn

#   # Client VPN
#   client_vpn_cidr_block = var.client_vpn_cidr_block
#   dns_servers           = var.client_vpn_dns_servers
#   split_tunnel          = var.client_vpn_split_tunnel
#   tags                  = var.tags

#   # Group Names
#   authorize_groups = var.sso_identity_groups

# }


module "vpc-windows" {
  source = "../../../../modules/network/vpc"

  prefix                       = var.prefix
  name                         = "vpc-windows"
  cidr                         = var.vpc["vpc-windows"].cidr
  availability_zones           = ["${var.region}a", "${var.region}b", "${var.region}c"]
  private_subnets              = var.vpc["vpc-windows"].private_subnets
  public_subnets               = var.vpc["vpc-windows"].public_subnets
  database_subnets             = var.vpc["vpc-windows"].database_subnets
  enable_nat_gateway           = var.vpc["vpc-windows"].enable_nat_gateway
  single_nat_gateway           = var.vpc["vpc-windows"].single_nat_gateway
  one_nat_gateway_per_az       = var.vpc["vpc-windows"].one_nat_gateway_per_az
  create_database_subnet_group = var.vpc["vpc-windows"].create_database_subnet_group

  private_subnet_tags  = var.vpc["vpc-windows"].private_subnet_tags
  public_subnet_tags   = var.vpc["vpc-windows"].public_subnet_tags
  database_subnet_tags = var.vpc["vpc-windows"].database_subnet_tags

  # Flow Logs
  enable_flow_log                                 = var.enable_flow_log
  create_flow_log_cloudwatch_log_group            = var.create_flow_log_cloudwatch_log_group
  create_flow_log_cloudwatch_iam_role             = var.create_flow_log_cloudwatch_iam_role
  flow_log_max_aggregation_interval               = var.flow_log_max_aggregation_interval
  flow_log_cloudwatch_log_group_retention_in_days = var.flow_log_cloudwatch_log_group_retention_in_days
  flow_log_cloudwatch_log_group_class             = var.flow_log_cloudwatch_log_group_class
  tags                                            = var.tags

  # Only create the Windows VPC if configuration is provided
  count = lookup(var.vpc, "vpc-windows", null) != null ? 1 : 0
}