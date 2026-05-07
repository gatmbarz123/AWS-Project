output "usage_instructions" {
  value = {
    for name, mirror in module.ecr_mirror : name => mirror.usage_instructions
  }
}
