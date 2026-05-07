data "aws_secretsmanager_secret" "datadog_secrets" {
  name = "mang/Datadog"
}