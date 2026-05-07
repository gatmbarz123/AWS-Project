
module "eks" {
  source = "../../../../modules/compute/eks"

  prefix         = "${var.prefix}-${each.key}"
  vpc_id         = data.aws_vpc.vpc.id
  vpc_cidr_block = data.aws_vpc.vpc.cidr_block
  subnet_ids     = data.aws_subnets.private_subnets.ids

  cluster_version                        = var.cluster_version
  create_cloudwatch_log_group            = lookup(var.eks, "create_cloudwatch_log_group", true)
  cloudwatch_log_group_retention_in_days = lookup(var.eks, "cloudwatch_log_group_retention_in_days", 7)
  cluster_enabled_log_types              = lookup(var.eks, "cluster_enabled_log_types", ["api", "audit", "authenticator", "controllerManager", "scheduler"])
  cluster_endpoint_private_access        = lookup(var.eks, "cluster_endpoint_private_access", true)
  cluster_endpoint_public_access         = lookup(each.value, "cluster_endpoint_public_access", false)

  for_each                  = var.eks
  access_entries            = each.value.access_entries
  node_group_ami_type       = each.value.node_group_ami_type
  node_group_disk_size      = each.value.node_group_disk_size
  node_group_min_size       = each.value.node_group_min_size
  node_group_max_size       = each.value.node_group_max_size
  node_group_desired_size   = each.value.node_group_desired_size
  node_group_instance_types = each.value.node_group_instance_types
  node_group_capacity_type  = each.value.node_group_capacity_type

  additional_cluster_security_group_rules = lookup(each.value, "additional_cluster_security_group_rules", {})


  # Karpenter
  enable_karpenter_spot_termination = lookup(each.value, "enable_karpenter_spot_termination", true)



  tags = var.tags
}

