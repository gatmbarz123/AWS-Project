# General
variable "prefix" {
  type        = string
  description = "Prefix for resource names"
}

variable "aws_account_id" {
  type        = string
  description = "AWS account ID"
}

variable "partition" {
  type        = string
  description = "AWS partition (e.g. aws-us-gov)"
}

variable "region" {
  type        = string
  description = "AWS region"
}

# Network
variable "vpc_id" {
  type        = string
  description = "VPC ID where runners will be deployed"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Private subnet IDs for runner instances"
}

# EC2
variable "ami_id" {
  type        = string
  description = "AMI ID for runner instances (Amazon Linux 2023 recommended)"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type for runners"
  default     = "m5.large"
}

# ASG
variable "asg_min_size" {
  type        = number
  description = "Minimum number of runner instances"
  default     = 1
}

variable "asg_max_size" {
  type        = number
  description = "Maximum number of runner instances"
  default     = 5
}

variable "asg_desired_capacity" {
  type        = number
  description = "Desired number of runner instances"
  default     = 1
}

# GitHub
variable "github_config_url" {
  type        = string
  description = "GitHub org or repo URL to register runners with (e.g. https://github.com/my-org or https://github.com/my-org/my-repo)"
}

variable "runner_labels" {
  type        = list(string)
  description = "Labels to assign to the GitHub Actions runner"
  default     = ["self-hosted", "linux", "x64"]
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
  type        = number
  description = "CPU utilization % threshold to trigger scale-out"
  default     = 80
}

variable "scale_in_cpu_threshold" {
  type        = number
  description = "CPU utilization % threshold to trigger scale-in"
  default     = 20
}

# Observability
variable "log_retention_days" {
  type        = number
  description = "CloudWatch log group retention in days"
  default     = 30
}

# KMS
variable "kms_deletion_window_in_days" {
  type        = number
  description = "KMS key deletion window in days"
  default     = 30
}

# Tags
variable "tags" {
  type        = map(string)
  description = "Tags to apply to all resources"
  default     = {}
}
