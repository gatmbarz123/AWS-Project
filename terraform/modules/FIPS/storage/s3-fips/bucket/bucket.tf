################################################################################
# S3 Buckets
################################################################################
resource "aws_s3_bucket" "s3" {
  bucket = "${var.prefix}-${var.name}"

  tags = merge(var.tags, {
    Name = "${var.prefix}-${var.name}"
  })
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket                  = aws_s3_bucket.s3.id
  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets
}

resource "aws_s3_bucket_versioning" "s3_version" {
  bucket = aws_s3_bucket.s3.id
  versioning_configuration {
    status = var.versioning_status
  }
}

resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.s3.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "s3_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.this]
  bucket     = aws_s3_bucket.s3.id
  acl        = "private"
}

resource "aws_s3_bucket_policy" "s3_policy" {
  count  = var.bucket_policy_file != null ? 1 : 0
  bucket = aws_s3_bucket.s3.id
  policy = var.bucket_policy_file
}

resource "aws_s3_bucket_logging" "s3_logging" {
  count = var.enable_logging ? 1 : 0

  bucket = aws_s3_bucket.s3.id

  target_bucket = var.logging_target_bucket
  target_prefix = var.logging_target_prefix != null ? var.logging_target_prefix : "${var.name}/"
}

# FIPS 

resource "aws_s3_bucket_policy" "fips_tls_policy" {
  bucket = aws_s3_bucket.s3.id

  policy = templatefile("../../../../main/common/policies/bucket/s3_fips_bucket_policy.json.tpl", {
    BUCKET_ARN = aws_s3_bucket.s3.arn
  })
}

resource "aws_s3_bucket_server_side_encryption_configuration" "fips_encryption" {
  bucket = aws_s3_bucket.s3.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = (var.kms_key_id != null && var.kms_key_id != "") ? "aws:kms" : "AES256"
      kms_master_key_id = var.kms_key_id
    }
    bucket_key_enabled = true
  }
}
