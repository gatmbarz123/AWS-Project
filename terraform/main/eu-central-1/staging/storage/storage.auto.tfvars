s3_buckets = {
  "example-projects" = {
    enable_logging        = true
    logging_target_bucket = "stg-euc1-example-datadog-logs"
    logging_target_prefix = "example-projects/"
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
  "example-projects-api" = {
    enable_logging        = true
    logging_target_bucket = "stg-euc1-example-datadog-logs"
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
