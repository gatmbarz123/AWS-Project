data "aws_iam_role" "config_slr" {
  count = var.manage_service_linked_role ? 0 : 1
  name  = "AWSServiceRoleForConfig"
}
