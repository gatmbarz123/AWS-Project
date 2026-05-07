output "user_name" {
  value = aws_iam_user.user.name
}

output "secret_arn" {
  value       = aws_secretsmanager_secret.credentials.arn
  description = "ARN of the Secrets Manager secret containing the user's access key credentials"
}
