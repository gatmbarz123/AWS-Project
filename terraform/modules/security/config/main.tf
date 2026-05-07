resource "aws_iam_service_linked_role" "config" {
  count            = var.manage_service_linked_role ? 1 : 0
  aws_service_name = "config.amazonaws.com"
}

resource "aws_config_configuration_recorder" "config_recorder" {
  name     = "${var.prefix}-config-recorder"
  role_arn = try(aws_iam_service_linked_role.config[0].arn, data.aws_iam_role.config_slr[0].arn)

  recording_group {
    all_supported                 = true
    include_global_resource_types = true
  }
}

resource "aws_config_delivery_channel" "config" {
  name           = "${var.prefix}-config-delivery-channel"
  s3_bucket_name = var.s3_bucket_name_logs # put here the name of the bucket 
  depends_on     = [aws_config_configuration_recorder.config_recorder]
}


resource "aws_config_configuration_recorder_status" "config" {
  name       = aws_config_configuration_recorder.config_recorder.name
  is_enabled = true
  depends_on = [aws_config_delivery_channel.config]
}

#--------------------------------------------------------- Config settings ^

#--------------------------------------------------------- Config Rules v

resource "aws_config_config_rule" "dynamic_config_rules" {
  for_each = { for rule in var.config_rules : rule.name => rule }

  name = each.value.name

  source {
    owner             = "AWS"
    source_identifier = each.value.source_identifier
  }

  depends_on = [aws_config_configuration_recorder.config_recorder]
}



resource "aws_config_config_rule" "iam_password_policy" {
  name = "iam-password-policy"
  source {
    owner             = "AWS"
    source_identifier = "IAM_PASSWORD_POLICY"
  }

  # add input parameters for password policy
  input_parameters = jsonencode({
    RequireUppercaseCharacters = "true"
    RequireLowercaseCharacters = "true"
    RequireNumbers             = "true"
    MinimumPasswordLength      = "14"
    RequireSymbols             = "true"
    PasswordReusePrevention    = "24"
    MaxPasswordAge             = "90"
  })

  depends_on = [aws_config_configuration_recorder.config_recorder]
}
