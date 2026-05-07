# Cloudtrail
module "cloudtrail" {
  source = "../../../../modules/security/cloudtrail"

  prefix                 = var.prefix
  name                   = var.cloudtrail_name
  s3_bucket_name         = var.cloudtrail_centralized_s3_bucket_name
  log_group_class        = var.cloudtrail_log_group_class
  admin_emails           = var.cloudtrail_admin_emails
  security_sources       = var.security_sources
  security_event_names   = var.security_event_names
  security_event_sources = var.security_event_sources
  security_detail_types  = var.security_detail_types

  tags = var.tags
}

module "config" {
  source              = "../../../../modules/security/config"
  prefix              = var.prefix
  s3_bucket_name_logs = var.config_centralized_s3_bucket_name
  config_rules        = var.config_rules

}
module "waf" {

  source                       = "../../../../modules/security/waf"
  prefix                       = var.prefix
  waf_ip_set_scope             = var.waf_ip_set_scope
  waf_ip_set_addresses_version = var.waf_ip_set_addresses_version
  allowed_ip_addresses         = var.allowed_ip_addresses

  white_list = var.white_list

  #-----------------------------------------------------WAF IP SET ^

  #-----------------------------------------------------WAF ACL RULES v

  waf_acl_scope  = var.waf_acl_scope
  default_action = var.default_action

  waf_rules = var.waf_rules

  cloudwatch_metrics_enabled = var.cloudwatch_metrics_enabled
  metric_name                = var.metric_name
  sampled_requests_enabled   = var.sampled_requests_enabled

  tags = var.tags
}