############
# Networking
############
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws" # https://github.com/terraform-aws-modules/terraform-aws-vpc
  version = "5.16.0"                        # https://github.com/terraform-aws-modules/terraform-aws-vpc/releases/tag/v5.16.0
  name    = "${var.prefix}-${var.name}"

  # Set the address space for VPC
  cidr = var.cidr

  # Set Availability Zones and Subnets
  azs             = var.availability_zones
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  manage_default_route_table    = false
  manage_default_network_acl    = false
  manage_default_security_group = false
  map_public_ip_on_launch       = true

  # Database Subnets
  create_database_subnet_group = var.create_database_subnet_group
  database_subnets             = var.database_subnets
  database_subnet_group_name   = var.name == "vpc" ? "${var.prefix}-db-subnet-group" : "${var.prefix}-${var.name}-db-subnet-group"

  # NAT Gateway
  enable_nat_gateway     = var.enable_nat_gateway
  single_nat_gateway     = var.single_nat_gateway # The nat gateway will be placed in the first public subnet.
  one_nat_gateway_per_az = var.one_nat_gateway_per_az

  #  Internet Gateway
  create_igw = true

  # The VPC must have DNS hostname and DNS resolution support, or EKS Fargate/EC2 nodes can't register with the EKS Cluster.
  # https://docs.aws.amazon.com/eks/latest/userguide/network_reqs.html
  enable_dns_hostnames = true

  # Tags for Karpenter discovery
  private_subnet_tags  = merge(var.private_subnet_tags, var.tags)
  public_subnet_tags   = merge(var.public_subnet_tags, var.tags)
  database_subnet_tags = merge(var.database_subnet_tags, var.tags)
  vpc_tags             = var.tags

  # VPC Flow Logs
  # Cloudwatch log group and IAM role will be created
  enable_flow_log                      = var.enable_flow_log
  create_flow_log_cloudwatch_log_group = var.create_flow_log_cloudwatch_log_group
  create_flow_log_cloudwatch_iam_role  = var.create_flow_log_cloudwatch_iam_role

  flow_log_max_aggregation_interval               = var.flow_log_max_aggregation_interval
  flow_log_cloudwatch_log_group_name_prefix       = "/aws/${var.prefix}-${var.name}/"
  flow_log_cloudwatch_log_group_retention_in_days = var.flow_log_cloudwatch_log_group_retention_in_days
  flow_log_cloudwatch_log_group_class             = var.flow_log_cloudwatch_log_group_class

  vpc_flow_log_tags = var.tags
}

