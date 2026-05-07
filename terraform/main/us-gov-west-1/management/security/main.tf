# Cloudtrail centralized s3 bucket
module "cloudtrail_centralized_s3_bucket" {
  source = "../../../../modules/storage/s3/bucket"

  prefix            = var.prefix
  name              = var.bucket_name_cloudtrail
  versioning_status = "Enabled"
  bucket_policy_file = templatefile("${var.s3_policy_path}/s3_cloudtrail_bucket_policy.json.tpl",
    {
      S3_BUCKET_NAME = "${var.prefix}-${var.bucket_name_cloudtrail}"
      PARTITION      = data.aws_partition.current.partition
      S3_BUCKET_KEY_PREFIXES = jsonencode([
        "arn:aws-us-gov:s3:::${var.prefix}-${var.bucket_name_cloudtrail}/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
        "arn:aws-us-gov:s3:::${var.prefix}-${var.bucket_name_cloudtrail}/AWSLogs/${var.production_account_id}/*",
        "arn:aws-us-gov:s3:::${var.prefix}-${var.bucket_name_cloudtrail}/AWSLogs/${var.dev_qa_account_id}/*",
        # "arn:aws-us-gov:s3:::${var.prefix}-${var.bucket_name_cloudtrail}/AWSLogs/${var.playground_account_id}/*",
        # "arn:aws-us-gov:s3:::${var.prefix}-${var.bucket_name_cloudtrail}/AWSLogs/${var.staging_account_id}/*",
        # "arn:aws-us-gov:s3:::${var.prefix}-${var.bucket_name_cloudtrail}/AWSLogs/${var.demo_account_id}/*"
      ])
      CLOUD_TRAIL_ARNS = jsonencode([
        "arn:aws-us-gov:cloudtrail:${var.region}:${data.aws_caller_identity.current.account_id}:trail/management-events",
        "arn:aws-us-gov:cloudtrail:${var.region}:${var.production_account_id}:trail/management-events",
        "arn:aws-us-gov:cloudtrail:${var.region}:${var.dev_qa_account_id}:trail/management-events",
        # "arn:aws-us-gov:cloudtrail:${var.region}:${var.playground_account_id}:trail/management-events",
        # "arn:aws-us-gov:cloudtrail:${var.region}:${var.staging_account_id}:trail/management-events",
        # "arn:aws-us-gov:cloudtrail:${var.region}:${var.demo_account_id}:trail/management-events"
      ])
  })

  tags = var.tags
}

# Cloudtrail
module "cloudtrail" {
  source = "../../../../modules/security/cloudtrail"

  prefix                 = var.prefix
  name                   = var.cloudtrail_name
  s3_bucket_name         = module.cloudtrail_centralized_s3_bucket.name
  log_group_class        = var.cloudtrail_log_group_class
  admin_emails           = var.cloudtrail_admin_emails
  security_sources       = var.security_sources
  security_event_names   = var.security_event_names
  security_event_sources = var.security_event_sources
  security_detail_types  = var.security_detail_types

  tags = var.tags
}



module "config" {
  source = "../../../../modules/security/config"

  prefix                     = var.prefix
  s3_bucket_name_logs        = module.config_centralized_s3_bucket.name
  config_rules               = var.config_rules
  manage_service_linked_role = true
}

module "config_security_hub" {
  source                = "../../../../modules/config-securityhub"
  account_id            = data.aws_caller_identity.current.account_id
  region                = var.region
  is_management_account = var.is_management_account
  member_account_ids    = var.member_account_ids
}

module "config_centralized_s3_bucket" {
  source = "../../../../modules/storage/s3/bucket"

  prefix            = var.prefix
  name              = var.bucket_name_config
  versioning_status = "Enabled"
  bucket_policy_file = templatefile("${var.s3_policy_path}/s3_config_bucket_policy.json.tpl",
    {
      S3_BUCKET_NAME = "${var.prefix}-${var.bucket_name_config}"
      PARTITION      = data.aws_partition.current.partition
      ORGANIZATION_ACCOUNT_IDS = jsonencode([
        data.aws_caller_identity.current.account_id,
        var.production_account_id,
        var.dev_qa_account_id,
        # var.playground_account_id,
        # var.staging_account_id,
        # var.demo_account_id
      ])
  })
  tags = var.tags
}

#---------------------------------------------------------------------- AWS GuardDuty
module "guardduty" {
  source = "../../../../modules/security/guardduty"

  guardduty_enable                 = var.guardduty_enable
  auto_enable_organization_members = var.auto_enable_organization_members
  configuration_features           = var.guardduty_configuration_features
  admin_account_id                 = data.aws_caller_identity.current.account_id
}

