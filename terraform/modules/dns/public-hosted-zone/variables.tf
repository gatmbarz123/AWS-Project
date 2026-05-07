variable "name" {
  description = "A list of private hosted zone names"
  type        = string
}

variable "tags" {
  description = "A mapping of tags to assign to the public hosted zone"
  type        = map(string)
}
