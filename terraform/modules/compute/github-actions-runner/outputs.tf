output "asg_name" {
  description = "Name of the Auto Scaling Group"
  value       = aws_autoscaling_group.runner.name
}

output "iam_role_arn" {
  description = "ARN of the runner IAM role"
  value       = aws_iam_role.runner.arn
}

output "iam_role_name" {
  description = "Name of the runner IAM role"
  value       = aws_iam_role.runner.name
}

output "security_group_id" {
  description = "ID of the runner security group"
  value       = aws_security_group.runner.id
}

output "cache_bucket_name" {
  description = "Name of the S3 cache bucket"
  value       = aws_s3_bucket.cache.id
}

output "kms_key_arn" {
  description = "ARN of the KMS key"
  value       = aws_kms_key.this.arn
}

output "log_group_name" {
  description = "CloudWatch log group name"
  value       = aws_cloudwatch_log_group.runner.name
}
