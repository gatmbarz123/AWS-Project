
# Cloudtrail !
module "cloudtrail" {
  source = "../../../../modules/security/cloudtrail"

  prefix          = var.prefix
  name            = var.cloudtrail_name
  s3_bucket_name  = var.cloudtrail_centralized_s3_bucket_name
  log_group_class = var.cloudtrail_log_group_class
  tags            = var.tags
}
