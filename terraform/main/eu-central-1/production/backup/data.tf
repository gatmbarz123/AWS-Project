data "aws_kms_alias" "backup_source" {
  name = "alias/aws/backup"
}

data "aws_rds_cluster" "rds" {
  for_each = {
    for k, v in var.backup_config : k => v
    if v.resource_type == "rds"
  }

  cluster_identifier = each.value.resource_name
}

data "aws_s3_bucket" "s3_buckets" {
  for_each = {
    for k, v in var.backup_config : k => v
    if v.resource_type == "s3"
  }

  bucket = each.value.resource_name
}