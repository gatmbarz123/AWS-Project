# VPC
variable "prefix" {
  type = string
}

variable "name" {
  type = string
}
variable "cidr" {
  type = string
}

variable "availability_zones" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}

variable "public_subnets" {
  type = list(string)
}

variable "database_subnets" {
  type = list(string)
}

variable "enable_nat_gateway" {
  type = bool
}

variable "single_nat_gateway" {
  type = bool
}

variable "one_nat_gateway_per_az" {
  type = bool
}

variable "create_database_subnet_group" {
  type = bool
}

variable "private_subnet_tags" {
  type = map(string)
}

variable "public_subnet_tags" {
  type = map(string)
}

variable "database_subnet_tags" {
  type = map(string)
}


# Flow Logs
variable "enable_flow_log" {
  type = bool
}
variable "create_flow_log_cloudwatch_log_group" {
  type = bool
}
variable "create_flow_log_cloudwatch_iam_role" {
  type = bool
}
variable "flow_log_max_aggregation_interval" {
  type    = number
  default = null
}
variable "flow_log_cloudwatch_log_group_retention_in_days" {
  type    = number
  default = null
}
variable "flow_log_cloudwatch_log_group_class" {
  type    = string
  default = null
}

variable "tags" {
  type = map(string)
}