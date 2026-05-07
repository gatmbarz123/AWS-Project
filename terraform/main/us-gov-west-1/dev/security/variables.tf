variable "prefix" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "cloudtrail_centralized_s3_bucket_name" {
  type = string
}

variable "cloudtrail_log_group_class" {
  type = string
}

variable "cloudtrail_name" {
  type = string
}

variable "cloudtrail_admin_emails" {
  type = list(string)
}

variable "security_event_sources" {
  type = list(string)
}

variable "security_event_names" {
  type = list(string)
}

variable "security_sources" {
  type = list(string)
}

variable "security_detail_types" {
  type = list(string)
}

#-------------------------------------------------------------Cloudtrail 

#-------------------------------------------------------------- WAF

variable "waf_ip_set_scope" {
  type = string
}

variable "waf_ip_set_addresses_version" {
  type = string
}

variable "allowed_ip_addresses" {
  type = list(string)
}

#-----------------------------------------------------WAF IP SET ^

#-----------------------------------------------------WAF ACL RULES v

variable "waf_acl_scope" {
  type = string
}

variable "default_action" {
  type = string
}

variable "white_list" {
  type = list(object({
    name                       = string
    priority                   = number
    cloudwatch_metrics_enabled = bool
    metric_name                = string
    sampled_requests_enabled   = bool
  }))
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
}


variable "geo_allow_countries" {
  type    = list(string)
  default = []
}

variable "cloudwatch_metrics_enabled" {
  type = bool
}

variable "metric_name" {
  type = string
}

variable "sampled_requests_enabled" {
  type = bool
}

#--------------------------------------------------------------------- AWS WAF


#----------------------------------------------------------------------- AWS Config 

variable "config_centralized_s3_bucket_name" {
  type = string
}

variable "config_rules" {
  type = list(object({
    name              = string
    source_identifier = string
  }))
}

variable "region" {
  type = string
}

variable "environment" {
  type = string
}

variable "is_management_account" {
  description = "Set to true if this is the management account."
  type        = bool
  default     = false
}

variable "member_account_ids" {
  description = "List of AWS Organization member account IDs (only needed in management account)."
  type        = list(string)
  default     = []
}