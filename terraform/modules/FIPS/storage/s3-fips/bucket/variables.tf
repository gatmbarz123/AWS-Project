#  General
variable "prefix" {
  description = "Prefix for the resources"
  type        = string
}

# S3
variable "name" {
  description = "S3 bucket name"
  type        = string
}

variable "block_public_acls" {
  description = "Whether Amazon S3 should block public ACLs for this bucket"
  type        = bool
  default     = true
}

variable "block_public_policy" {
  description = "Whether Amazon S3 should block public bucket policies for this bucket"
  type        = bool
  default     = true
}

variable "ignore_public_acls" {
  description = "Whether Amazon S3 should ignore public ACLs for this bucket"
  type        = bool
  default     = true
}

variable "restrict_public_buckets" {
  description = "Whether Amazon S3 should restrict public bucket policies for this bucket"
  type        = bool
  default     = true
}

variable "versioning_status" {
  description = "Enable versioning"
  type        = string
  default     = "Disabled"
}

variable "bucket_policy_file" {
  description = "Path to the bucket policy file"
  type        = string
  default     = null
}

variable "enable_logging" {
  description = "Enable server access logging for the S3 bucket"
  type        = bool
  default     = false
}

variable "logging_target_bucket" {
  description = "The name of the bucket where you want Amazon S3 to store server access logs"
  type        = string
  default     = null
}

variable "logging_target_prefix" {
  description = "A prefix for all log object keys (e.g., 'logs/' creates a 'logs/' folder in the target bucket)"
  type        = string
  default     = null
}


variable "tags" {
  description = "Tags for the S3 bucket"
  type        = map(string)
}

variable "kms_key_id" {
  description = "KMS CMK ID or ARN for SSE-KMS. If null, uses SSE-S3 (AES256)."
  type        = string
  default     = null
}