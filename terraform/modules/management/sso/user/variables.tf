variable "display_name" {
  type = string
}

variable "user_name" {
  type = string
}

variable "name" {
  type = object({
    given_name  = string
    family_name = string
  })
}

variable "emails" {
  type = list(object({
    value = string
  }))
}
