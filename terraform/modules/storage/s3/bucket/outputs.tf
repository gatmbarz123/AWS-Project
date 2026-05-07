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