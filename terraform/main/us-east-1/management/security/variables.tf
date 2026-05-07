variable "prefix" {
  type = string
}

variable "region" {
  type = string
}

variable "bucket_name_cloudtrail" {
  type = string
}

variable "cloudtrail_name" {
  type = string
}

variable "cloudtrail_log_group_class" {
  type = string
}

variable "s3_policy_path" {
  type = string
}

variable "tags" {
  type = map(string)
}

# Cloudtrail Accounts
variable "dev_qa_account_id" {
  type = string
}

variable "playground_account_id" {
  type = string
}

variable "staging_account_id" {
  type = string
}

variable "production_account_id" {
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
#AWS Config 

variable "config_rules" {
  type = list(object({
    name              = string
    source_identifier = string
  }))
}


#AWS Config -s3 

variable "bucket_name_config" {
  type = string
}

#---------------------------------------------------------------------- AWS GuardDuty

variable "guardduty_enable" {
  type = bool
}

variable "auto_enable_organization_members" {
  type = string
}

variable "guardduty_configuration_features" {
  type = map(any)
}

