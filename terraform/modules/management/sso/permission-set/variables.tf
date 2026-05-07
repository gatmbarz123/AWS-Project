variable "name" {
  type = string
}

variable "description" {
  type = string
}

variable "inline_policy" {
  type    = string
  default = null
}

variable "managed_policy_arn" {
  type    = string
  default = null
}

variable "region" {
  type = string
}
