# locals {
#   backup_configs_with_arns = {
#     for k, v in var.backup_config : k => merge(v, {
#       service_arn = v.resource_type == "rds" ? data.aws_rds_cluster.rds[k].arn : data.aws_s3_bucket.s3_buckets[k].arn
#     })
#   }
# }
