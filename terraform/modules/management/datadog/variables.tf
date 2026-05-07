variable "prefix" {
  type = string
}

variable "datadog_site" {
  type = string
}

variable "api_key_secret" {
  type = string
}

variable "tags" {
  description = "The tags for the CloudTrail"
  type        = map(string)
}

variable "template_url" {
  type    = string
  default = "https://datadog-cloudformation-template.s3.amazonaws.com/aws/forwarder/latest.yaml"
}