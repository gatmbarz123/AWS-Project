resource "aws_securityhub_account" "_" {
}

resource "aws_securityhub_standards_subscription" "nist_800_53" {
  standards_arn = "arn:aws-us-gov:securityhub:us-gov-west-1::standards/nist-800-53/v/5.0.0"
  depends_on    = [aws_securityhub_account._]
}

resource "aws_guardduty_detector" "guardduty_detector" {
  count  = var.is_management_account ? 0 : 1
  enable = true
}