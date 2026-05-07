variable "prefix" {
  description = "The prefix"
  type        = string
}

variable "name" {
  description = "The name of the IAM role."
  type        = string
}
variable "assume_role_policy" {
  description = "The policy that grants an entity permission to assume the role."
  type        = string
}
variable "tags" {
  description = "A map of tags to assign to the IAM role."
  type        = map(string)
}