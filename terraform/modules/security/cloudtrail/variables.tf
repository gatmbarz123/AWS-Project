variable "prefix" {
  description = "The prefix for the CloudTrail log group"
  type        = string
}

variable "name" {
  description = "The name for the CloudTrail"
  type        = string
}

variable "s3_bucket_name" {
  description = "The name of the S3 bucket to store the CloudTrail logs"
  type        = string
}

variable "log_group_class" {
  description = "The class of the CloudTrail log group"
  type        = string
}

variable "admin_emails" {
  type = list(string)
}

variable "security_event_sources" {
  type = list(string)
}

variable "security_event_names" {
  type = list(string)
}

variable "security_sources" {
  type = list(string)
}

variable "security_detail_types" {
  type = list(string)
}

variable "tags" {
  description = "The tags for the CloudTrail"
  type        = map(string)
}

