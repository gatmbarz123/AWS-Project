# create AWS cloud watch group in Production
resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/cloudtrail/${var.prefix}"
  retention_in_days = 30
  log_group_class   = var.log_group_class

  tags = var.tags
}

resource "aws_iam_role" "cloudtrail_cloudwatch_logs_role" {
  name               = "${var.prefix}-cloudtrail-cloudwatch-logs-role"
  assume_role_policy = file("../../../../main/common/policies/iam/cloudtrail_assume_role_policy.json.tpl")
}

resource "aws_iam_role_policy" "cloudtrail_cloudwatch_logs_policy" {
  name = "${var.prefix}-cloudtrail-cloudwatch-logs-policy"
  role = aws_iam_role.cloudtrail_cloudwatch_logs_role.name
  policy = templatefile("../../../../main/common/policies/iam/cloudtrail_cloudwatch_policy.json.tpl", {
    LOG_STREAM_ARN = "${aws_cloudwatch_log_group.this.arn}:*"
  })
}

#Create the CloudTrail in the production account and set up the S3 delivery
resource "aws_cloudtrail" "this" {
  name           = var.name
  s3_bucket_name = var.s3_bucket_name

  kms_key_id                    = aws_kms_key.cloudtrail_key.arn
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_logging                = true
  enable_log_file_validation    = true
  is_organization_trail         = false

  cloud_watch_logs_group_arn = "${aws_cloudwatch_log_group.this.arn}:*"
  cloud_watch_logs_role_arn  = aws_iam_role.cloudtrail_cloudwatch_logs_role.arn
  event_selector {
    read_write_type           = "All"
    include_management_events = true

    data_resource {
      type   = "AWS::S3::Object"
      values = ["arn:${data.aws_partition.current.partition}:s3:::"]
    }
  }

  tags = var.tags
}


resource "aws_kms_key" "cloudtrail_key" {
  description             = "KMS key for CloudTrail log encryption"
  deletion_window_in_days = 7
  enable_key_rotation     = true
  rotation_period_in_days = 365

  policy = templatefile("../../../../main/common/policies/iam/cloudtrail_policy_kms_key.json.tpl",
    {
      ACCOUNT_ID = data.aws_caller_identity.current.account_id
      PARTITION  = data.aws_partition.current.partition
      REGION     = data.aws_region.current.name
      NAME       = var.name
  })

  tags = var.tags
}

resource "aws_kms_alias" "cloudtrail_key" {
  name          = "alias/${var.prefix}-cloudtrail"
  target_key_id = aws_kms_key.cloudtrail_key.key_id
}


# SNS + KMS Key + Eventbridge

resource "aws_sns_topic" "cloudtrail_alerts" {
  name              = "${var.prefix}-cloudtrail-alerts"
  kms_master_key_id = aws_kms_key.sns_key.id

  tags = var.tags
}

resource "aws_sns_topic_policy" "cloudtrail_alerts" {
  arn = aws_sns_topic.cloudtrail_alerts.arn

  policy = templatefile("../../../../main/common/policies/iam/cloudtrail_sns_topic_policy.json.tpl", {
    SNS_TOPIC_ARN = aws_sns_topic.cloudtrail_alerts.arn
  })

}

resource "aws_sns_topic_subscription" "cloudtrail_alerts" {
  for_each = toset(var.admin_emails)

  topic_arn = aws_sns_topic.cloudtrail_alerts.arn
  protocol  = "email"
  endpoint  = each.value
}

resource "aws_kms_key" "sns_key" {
  description             = "KMS key for SNS log encryption"
  deletion_window_in_days = 7
  enable_key_rotation     = true
  rotation_period_in_days = 365

  policy = templatefile("../../../../main/common/policies/iam/sns_policy_kms_key.json.tpl",
    {
      PARTITION  = data.aws_partition.current.partition
      ACCOUNT_ID = data.aws_caller_identity.current.account_id
  })

  tags = var.tags
}

resource "aws_kms_alias" "sns_key" {
  name          = "alias/${var.prefix}-sns"
  target_key_id = aws_kms_key.sns_key.key_id
}

resource "aws_cloudwatch_event_rule" "security_events" {
  name        = "${var.prefix}-security-events"
  description = "Captures security events for IAM, EC2, and KMS"

  event_pattern = templatefile("../../../../main/common/policies/iam/security_events_pattern.json.tpl", {
    SOURCES       = var.security_sources
    EVENT_SOURCES = var.security_event_sources
    EVENT_NAMES   = var.security_event_names
    DETAIL_TYPE   = var.security_detail_types
  })

  tags = var.tags
}

resource "aws_cloudwatch_event_target" "security_events_sns" {
  rule      = aws_cloudwatch_event_rule.security_events.name
  target_id = "SendToSNS"
  arn       = aws_sns_topic.cloudtrail_alerts.arn
  role_arn  = aws_iam_role.eventbridge_sns_role.arn

  input_transformer {
    input_paths = {
      event_name   = "$.detail.eventName"
      user_type    = "$.detail.userIdentity.type"
      user_arn     = "$.detail.userIdentity.arn"
      role_name    = "$.detail.userIdentity.sessionContext.sessionIssuer.userName"
      source_ip    = "$.detail.sourceIPAddress"
      account      = "$.account"
      region       = "$.detail.awsRegion"
      time         = "$.time"
      user_agent   = "$.detail.userAgent"
      event_source = "$.detail.eventSource"
      instance_id  = "$.detail.requestParameters.instancesSet.items[0].instanceId"
      event_id     = "$.detail.eventID"
    }

    input_template = <<-EOT
"SECURITY ALERT - CloudTrail Event"
""
"ACTION: <event_name>"
"WHO: <role_name> (<user_type>)"
"FROM: <source_ip>"
"WHEN: <time>"
"ACCOUNT: <account>"
"REGION: <region>"
""
"DETAILS:"
"• Service: <event_source>"
"• Tool: <user_agent>"
"• Resource: <instance_id>"
"• Event ID: <event_id>"
""
"Full ARN: <user_arn>"
EOT
  }
}

resource "aws_iam_role" "eventbridge_sns_role" {
  name               = "${var.prefix}-eventbridge-sns-role"
  assume_role_policy = file("../../../../main/common/policies/iam/eventbridge_assume_role_policy.json.tpl")

  tags = var.tags
}

resource "aws_iam_role_policy" "eventbridge_sns_policy" {
  name = "${var.prefix}-eventbridge-sns-policy"
  role = aws_iam_role.eventbridge_sns_role.id

  policy = templatefile("../../../../main/common/policies/iam/eventbridge_sns_policy.json.tpl", {
    SNS_TOPIC_ARN = aws_sns_topic.cloudtrail_alerts.arn
    KMS_KEY_ARN   = aws_kms_key.sns_key.arn
  })
}
