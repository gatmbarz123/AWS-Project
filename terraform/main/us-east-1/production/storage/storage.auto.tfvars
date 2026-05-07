s3_buckets = {
  "example-projects" = {
    versioning_status     = "Enabled"
    enable_logging        = true
    logging_target_bucket = "prod-use1-example-datadog-logs"
    logging_target_prefix = "example-projects/"
  }

  "example-projects-api" = {
    versioning_status     = "Enabled"
    enable_logging        = true
    logging_target_bucket = "prod-use1-example-datadog-logs"
    logging_target_prefix = "example-projects-api/"
    create_sqs            = true
    sqs_notifications = [
      {
        events = ["s3:ObjectCreated:*"]
      }
    ]
    cors_rules = [
      {
        allowed_headers = ["*"]
        allowed_methods = ["GET", "PUT", "HEAD"]
        allowed_origins = ["*"]
        expose_headers  = ["ETag"]
      }
    ]
  }

  "example-datadog-logs" = {
    versioning_status = "Enabled"
  }
}

# KMS module inputs
kms_description             = "CMK for S3 SSE-KMS - prod use1"
kms_alias                   = "s3-fips"
kms_rotation_period_in_days = 365
kms_deletion_window_in_days = 7
kms_multi_region            = false
