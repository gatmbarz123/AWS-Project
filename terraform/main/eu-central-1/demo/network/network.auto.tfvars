# VPC
cidr = "10.53.0.0/16"

private_subnets  = ["10.53.0.0/22", "10.53.4.0/22", "10.53.8.0/22"]
public_subnets   = ["10.53.12.0/22", "10.53.16.0/22", "10.53.20.0/22"]
database_subnets = ["10.53.24.0/22", "10.53.28.0/22", "10.53.32.0/22"]

enable_nat_gateway           = true
single_nat_gateway           = true
one_nat_gateway_per_az       = false
create_database_subnet_group = true

private_subnet_tags = {
  "kubernetes.io/role/internal-elb"                = "1"
  "Tier"                                           = "private"
  "karpenter.sh/discovery/demo-euc1-web-eks"       = "true"
  "karpenter.sh/discovery/demo-euc1-python-ai-eks" = "true"
}
public_subnet_tags = {
  "kubernetes.io/role/elb" = "1"
  "Tier"                   = "public"
}
database_subnet_tags = {
  "Tier" = "database"
}

# VPC Flow Logs
enable_flow_log                                 = true
create_flow_log_cloudwatch_log_group            = true
create_flow_log_cloudwatch_iam_role             = true
flow_log_max_aggregation_interval               = 600
flow_log_cloudwatch_log_group_retention_in_days = 30
flow_log_cloudwatch_log_group_class             = "INFREQUENT_ACCESS"
