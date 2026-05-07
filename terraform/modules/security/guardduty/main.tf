resource "aws_guardduty_organization_admin_account" "example" {
  # depends_on = [aws_organizations_organization.example]

  admin_account_id = var.admin_account_id
}
resource "aws_guardduty_detector" "guardduty_detector" {
  enable = var.guardduty_enable
}

resource "aws_guardduty_organization_configuration_feature" "configuration_feature" {
  for_each    = var.configuration_features
  detector_id = aws_guardduty_detector.guardduty_detector.id

  name        = each.key
  auto_enable = "ALL"

  dynamic "additional_configuration" {
    for_each = try(each.value.additional_configurations, [])
    content {
      name        = additional_configuration.value.name
      auto_enable = additional_configuration.value.auto_enable
    }
  }
}

