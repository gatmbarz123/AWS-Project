output "key_id" {
  value       = aws_kms_key.this.key_id
  description = "Key ID"
}

output "key_arn" {
  value       = aws_kms_key.this.arn
  description = "Key ARN"
}

output "alias_name" {
  value       = try(aws_kms_alias.this[0].name, null)
  description = "Alias name"
}
