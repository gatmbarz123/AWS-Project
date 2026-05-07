module "s3" {
  source = "../../../../modules/storage/s3/bucket"

  prefix = var.prefix

  for_each = var.s3_buckets

  name              = each.key
  versioning_status = lookup(each.value, "versioning_status", "Disabled")

  tags = var.tags
}
