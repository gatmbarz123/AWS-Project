module "datadog-lambda" {
  source = "../../../../modules/management/datadog"
  prefix = var.prefix

  api_key_secret = data.aws_secretsmanager_secret.datadog_secrets.arn
  datadog_site   = "datadoghq.com"
  template_url   = "https://datadog-cloudformation-template.s3.amazonaws.com/aws/forwarder/latest.yaml"

  tags = var.tags
}