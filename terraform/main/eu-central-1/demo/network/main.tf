# Network project will include VPC, VPC Endpoints and VPN

module "vpc" {
  source = "../../../../modules/network/vpc"

  prefix                       = var.prefix
  name                         = "vpc"
  cidr                         = var.cidr
  availability_zones           = ["${var.region}a", "${var.region}b", "${var.region}c"]
  private_subnets              = var.private_subnets
  public_subnets               = var.public_subnets
  database_subnets             = var.database_subnets
  enable_nat_gateway           = var.enable_nat_gateway
  single_nat_gateway           = var.single_nat_gateway
  one_nat_gateway_per_az       = var.one_nat_gateway_per_az
  create_database_subnet_group = var.create_database_subnet_group

  private_subnet_tags  = var.private_subnet_tags
  public_subnet_tags   = var.public_subnet_tags
  database_subnet_tags = var.database_subnet_tags

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
  vpc_cidr_block = var.cidr

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
