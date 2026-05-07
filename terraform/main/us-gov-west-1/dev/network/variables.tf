# General
variable "environment" {
  type = string
}
variable "short_environment" {
  type = string
}
variable "aws_account_id" {
  type = string
}
variable "region" {
  type = string
}
variable "short_region" {
  type = string
}
variable "prefix" {
  type = string
}

# VPC Configuration
variable "vpc" {
  description = "Map of VPC configurations"
  type        = map(any)
  default     = {}
}

# Flow Logs
variable "enable_flow_log" {
  type    = bool
  default = true
}
variable "create_flow_log_cloudwatch_log_group" {
  type    = bool
  default = true
}
variable "create_flow_log_cloudwatch_iam_role" {
  type    = bool
  default = true
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
# Tags
variable "tags" {
  type = map(string)
}


# Client VPN
# variable "client_vpn_domain" {
#   type = string
# }
# variable "client_vpn_saml_provider_arn" {
#   type = string
# }
# variable "client_vpn_self_service_saml_provider_arn" {
#   type = string
# }
# variable "client_vpn_cidr_block" {
#   type = string
# }
# variable "client_vpn_dns_servers" {
#   type = list(string)
# }
# variable "client_vpn_split_tunnel" {
#   type = bool
# }
# variable "sso_identity_groups" {
#   type = any
# }
