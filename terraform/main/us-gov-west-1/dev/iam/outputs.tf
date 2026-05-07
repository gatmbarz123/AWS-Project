output "s3_user_secret_arn" {
  value = module.s3_user.secret_arn
}

output "s3_user_api_secret_arn" {
  value = module.s3_user_api.secret_arn
}

output "s3_python_user_secret_arn" {
  value = module.s3_python_user.secret_arn
}
