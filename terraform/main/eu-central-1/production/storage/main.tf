module "s3" {
  source = "../../../../modules/storage/s3/bucket"

  prefix = var.prefix

  for_each = var.s3_buckets

  name                  = each.key
  versioning_status     = lookup(each.value, "versioning_status", "Disabled")
  enable_logging        = lookup(each.value, "enable_logging", false)
  logging_target_bucket = lookup(each.value, "logging_target_bucket", null)
  logging_target_prefix = lookup(each.value, "logging_target_prefix", null)
  create_sqs            = lookup(each.value, "create_sqs", false)
  sqs_notifications     = lookup(each.value, "sqs_notifications", [])
  enable_eventbridge    = lookup(each.value, "enable_eventbridge", false)
  cors_rules            = lookup(each.value, "cors_rules", [])
  aws_account_id        = var.aws_account_id

  tags = var.tags
}
