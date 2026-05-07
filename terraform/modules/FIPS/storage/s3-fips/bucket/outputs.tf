output "id" {
  value = aws_s3_bucket.s3.id
}

output "name" {
  value = aws_s3_bucket.s3.bucket
}

output "bucket_domain_name" {
  value = aws_s3_bucket.s3.bucket_domain_name
}
output "arn" {
  value = aws_s3_bucket.s3.arn
}

output "kms_key_arn" {
  description = "ARN of the KMS key used for bucket encryption (provided)"
  value       = var.kms_key_id
}