variable "prefix" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "cloudtrail_centralized_s3_bucket_name" {
  type = string
}

variable "cloudtrail_log_group_class" {
  type = string
}

variable "cloudtrail_name" {
  type = string
}