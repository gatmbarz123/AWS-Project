# General
variable "policy_folder" {
  description = "The folder where the policies are stored"
  default     = "policies"
}

variable "name" {
  description = "The name of the service account"
  type        = string
}

variable "service_account_path" {
  description = "The path of the service account"
  type        = string
  default     = null
}

variable "inline_policies" {
  description = "The path of the policy"
  type        = list(any)
  default     = []
}
variable "managed_policies" {
  description = "The path of the policy"
  type        = list(string)
  default     = []
}
variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}
variable "create_pod_identity" {
  description = "Create the pod identity"
  type        = bool
}
variable "namespace" {
  description = "The namespace of the service account"
  type        = string
  default     = null
}
variable "service_account_name" {
  description = "The name of the service account"
  type        = string
  default     = null
}

variable "assume_role_policy" {
  description = "The assume role policy"
  type        = string
  default     = null
}