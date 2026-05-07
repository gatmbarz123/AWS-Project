module "datadog-lambda" {
  source = "../../../../modules/management/datadog"
  prefix = var.prefix

  api_key_secret = data.aws_secretsmanager_secret.datadog_secrets.arn
  datadog_site   = "datadoghq.eu"

  tags = var.tags
}