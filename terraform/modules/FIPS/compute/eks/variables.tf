# General
variable "prefix" {
  type = string
}

# VPC
variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "vpc_cidr_block" {
  type        = string
  description = "VPC CIDR block"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Private Subnets"
}

variable "cluster_endpoint_private_access" {
  type        = bool
  description = "Enable private access to the cluster endpoint"
  default     = true
}

variable "cluster_endpoint_public_access" {
  type        = bool
  description = "Enable public access to the cluster endpoint"
}

# EKS
variable "cluster_version" {
  description = "The Kubernetes version that is supported with Amazon EKS."
  type        = string
}
variable "create_cloudwatch_log_group" {
  description = "Determines whether a log group is created by this module for the cluster logs."
  type        = bool
}
variable "cluster_enabled_log_types" {
  description = "A list of the desired control plane logs to enable."
  type        = list(string)
}

variable "additional_cluster_security_group_rules" {
  type        = any
  description = "Additional rules to add to the cluster security group"
  default     = {}
}

variable "access_entries" {
  type = any
}

variable "cloudwatch_log_group_retention_in_days" {
  type    = number
  default = 1
}

variable "cloudwatch_log_group_class" {
  type    = string
  default = "INFREQUENT_ACCESS"
}

variable "node_group_ami_type" {
  type        = string
  description = "The AMI type for your node group"
}

variable "node_group_disk_size" {
  type        = number
  description = "The size of the EKS node group disk"
}

variable "node_group_min_size" {
  type        = number
  description = "The minimum number of nodes in the node group"
}

variable "node_group_max_size" {
  type        = number
  description = "The maximum number of nodes in the node group"
}

variable "node_group_desired_size" {
  type        = number
  description = "The desired number of nodes in the node group"
}

variable "node_group_instance_types" {
  type        = list(string)
  description = "The instance type of the node group"
}

variable "node_group_capacity_type" {
  type        = string
  description = "Node group ec2 type: ON_DEMAND/SPOT"
}

# Karpenter
variable "use_latest_ami_release_version" {
  type        = bool
  description = "Use the latest AMI release version for the Karpenter node group"
  default     = true
}

variable "node_group_release_version" {
  type        = string
  description = "AMI release version to pin for the Karpenter node group. Only used when use_latest_ami_release_version is false"
  default     = null
}

variable "enable_karpenter_spot_termination" {
  type        = bool
  description = "Enable spot termination handler for Karpenter"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to all resources"
}
