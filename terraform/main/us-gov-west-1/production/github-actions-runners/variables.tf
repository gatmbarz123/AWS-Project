# General (sourced from env.tfvars)
variable "environment" {
  type = string
}

variable "aws_account_id" {
  type = string
}

variable "prefix" {
  type = string
}

variable "region" {
  type = string
}

variable "tags" {
  type = map(string)
}

# EC2
variable "ami_id" {
  type        = string
  description = "AMI ID for runner instances"
}

variable "instance_type" {
  type    = string
  default = "m5.large"
}

# ASG
variable "asg_min_size" {
  type    = number
  default = 1
}

variable "asg_max_size" {
  type    = number
  default = 5
}

variable "asg_desired_capacity" {
  type    = number
  default = 1
}

# GitHub
variable "github_config_url" {
  type        = string
  description = "GitHub org or repo URL (e.g. https://github.com/my-org)"
}

variable "runner_labels" {
  type    = list(string)
  default = ["self-hosted", "linux", "x64"]
}

variable "github_app_id" {
  type        = string
  description = "GitHub App ID"
}

variable "github_app_installation_id" {
  type        = string
  description = "GitHub App installation ID for the org or repo"
}

variable "github_app_private_key_secret_arn" {
  type        = string
  description = "Secrets Manager secret ARN containing the GitHub App private key (PEM)"
}

# Scaling
variable "scale_out_cpu_threshold" {
  type    = number
  default = 80
}

variable "scale_in_cpu_threshold" {
  type    = number
  default = 20
}

# Observability
variable "log_retention_days" {
  type    = number
  default = 30
}

# KMS
variable "kms_deletion_window_in_days" {
  type    = number
  default = 30
}
