resource "aws_secretsmanager_secret" "eks" {
  count = var.secret_name_prefix == "python_ai" || var.secret_name_prefix == "python_ai_api" ? 0 : 1

  name        = "Application/${var.short_environment}/${var.short_region}/${var.secret_name_prefix}"
  description = "Secrets for ${var.secret_name_prefix} application in ${var.prefix} environment"
}

resource "aws_secretsmanager_secret_version" "eks" {
  count = var.secret_name_prefix == "python_ai" || var.secret_name_prefix == "python_ai_api" ? 0 : 1

  secret_id = aws_secretsmanager_secret.eks[count.index].id
  secret_string = jsonencode({
    SECRET_KEY_BASE     = "REPLACE_WITH_ACTUAL_VALUE"
    RDS_WRITER_ENDPOINT = "REPLACE_WITH_ACTUAL_VALUE"
    DATABASE_URL        = "REPLACE_WITH_ACTUAL_VALUE"
    PHX_HOST            = "REPLACE_WITH_ACTUAL_VALUE"
  })

  lifecycle {
    ignore_changes = [secret_string]
  }
}

resource "aws_secretsmanager_secret" "airtable" {
  count = var.secret_name_prefix == "python_ai" || var.secret_name_prefix == "python_ai_api" ? 0 : 1

  name        = "Application/${var.short_environment}/${var.short_region}/${var.secret_name_prefix}_airtable"
  description = "Secrets for ${var.secret_name_prefix} application in ${var.prefix} environment"
}

resource "aws_secretsmanager_secret_version" "airtable" {
  count = var.secret_name_prefix == "python_ai" || var.secret_name_prefix == "python_ai_api" ? 0 : 1

  secret_id = aws_secretsmanager_secret.airtable[count.index].id
  secret_string = jsonencode({
    AIRTABLE_KEY = "REPLACE_WITH_ACTUAL_VALUE"
  })

  lifecycle {
    ignore_changes = [secret_string]
  }
}

resource "aws_secretsmanager_secret" "s3" {
  name        = "Application/${var.short_environment}/${var.short_region}/${var.secret_name_prefix}_s3"
  description = "Secrets for ${var.secret_name_prefix} application in ${var.prefix} environment"
}

resource "aws_secretsmanager_secret_version" "s3" {
  secret_id = aws_secretsmanager_secret.s3.id
  secret_string = jsonencode({
    S3_ACCESS_KEY = "REPLACE_WITH_ACTUAL_VALUE"
    S3_SECRET     = "REPLACE_WITH_ACTUAL_VALUE"
  })

  lifecycle {
    ignore_changes = [secret_string]
  }
}
