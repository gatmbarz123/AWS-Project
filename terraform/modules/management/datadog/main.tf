resource "aws_cloudformation_stack" "datadog_forwarder" {
  name         = "${var.prefix}-datadog-forwarder"
  capabilities = ["CAPABILITY_IAM", "CAPABILITY_NAMED_IAM", "CAPABILITY_AUTO_EXPAND"]
  parameters = {
    DdApiKeySecretArn = var.api_key_secret,
    DdSite            = var.datadog_site,
    FunctionName      = "${var.prefix}-datadog-forwarder"
  }
  template_url = var.template_url

  tags = var.tags
}