variable "prefix" {
  type        = string
  description = "prefix for the waf"
}

variable "waf_ip_set_scope" {
  type        = string
  description = "scope of the waf ip set (REGIONAL or CLOUDFRONT)"
}

variable "waf_ip_set_addresses_version" {
  type        = string
  description = "ip address version (IPV4 or IPV6)"
}

variable "allowed_ip_addresses" {
  type        = list(string)
  description = "list of allowed ip addresses in cidr format"
}

#-----------------------------------------------------WAF IP SET ^

#-----------------------------------------------------WAF ACL RULES v


variable "waf_acl_scope" {
  type        = string
  description = "scope of the waf acl (REGIONAL or CLOUDFRONT)"
}

variable "default_action" {
  type        = string
  description = "default action for waf acl (allow or block)"
}

variable "white_list" {
  type = list(object({
    name                       = string
    priority                   = number
    cloudwatch_metrics_enabled = bool
    metric_name                = string
    sampled_requests_enabled   = bool
  }))
  description = "list of whitelist rules for the waf acl"
}



variable "waf_rules" {
  type = list(object({
    name                       = string
    priority                   = number
    override_action            = string
    vendor_name                = string
    cloudwatch_metrics_enabled = bool
    metric_name                = string
    sampled_requests_enabled   = bool
  }))
  description = "list of managed rule groups for waf acl"
}


variable "cloudwatch_metrics_enabled" {
  type        = bool
  description = "enable cloudwatch metrics for waf"
}

variable "metric_name" {
  type        = string
  description = "name of the cloudwatch metric"
}

variable "sampled_requests_enabled" {
  type        = bool
  description = "enable sampling of requests in cloudwatch"
}

variable "geo_allow_countries" {
  type        = list(string)
  description = "List of ISO 3166-1 alpha-2 country codes to allow (e.g. [\"US\", \"IL\"]). Empty list disables geo-match rule."
  default     = []
}

variable "tags" {
  type        = map(string)
  description = "tags for the waf"
}
