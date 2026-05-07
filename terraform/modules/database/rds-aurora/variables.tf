# General 
variable "secret_rotation_schedule" {
  description = "The rotation schedule for the RDS password"
  type        = string
  default     = null
}

variable "prefix" {
  description = "The prefix"
  type        = string
}

variable "tags" {
  description = "The tags"
  type        = map(string)
  default     = {}
}

# VPC
variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "vpc_cidr_block" {
  type        = string
  description = "VPC CIDR block"
}

# Aurora RDS
variable "name" {
  type = string
}

variable "engine" {
  type = string
}

variable "engine_version" {
  type = string
}

variable "ca_cert_identifier" {
  description = "The identifier of the CA certificate for the DB instance."
  type        = string
}

variable "db_subnet_group_name" {
  type = string
}

variable "database_name" {
  type    = string
  default = null
}

variable "rds_port" {
  type = number
}

variable "azs" {
  type = list(string)
}

variable "master_username" {
  type = string
}

variable "backup_retention_period" {
  type = number
}

variable "deletion_protection" {
  type = bool
}

variable "preferred_backup_window" {
  type = string
}

variable "skip_final_snapshot" {
  type = bool
}

variable "enabled_cloudwatch_logs_exports" {
  type = list(string)
}

variable "iam_database_authentication_enabled" {
  type = bool
}

variable "instance_count" {
  type = string
}

variable "instance_az" {
  type = string
}

variable "monitoring_interval" {
  type = string
}

variable "allow_major_version_upgrade" {
  type = bool
}


# GovCloud compatibility
variable "use_serverless" {
  description = "Whether to use Aurora Serverless v2 (not supported in GovCloud)"
  type        = bool
  default     = true
}

variable "instance_class" {
  description = "Instance class for provisioned instances (used when use_serverless = false)"
  type        = string
  default     = "db.serverless"
}
