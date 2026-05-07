# Backup vaults
resource "aws_backup_vault" "source" {
  name          = "${var.prefix}-${var.name}-source"
  kms_key_arn   = var.source_kms_key_arn != "" ? var.source_kms_key_arn : null
  force_destroy = var.force_destroy
  tags          = var.tags
}


resource "aws_backup_vault" "destination" {
  provider      = aws.dr # aws.alias 
  name          = "${var.prefix}-${var.name}-destination"
  kms_key_arn   = var.destination_kms_key_arn != "" ? var.destination_kms_key_arn : null
  force_destroy = var.force_destroy
  tags          = merge(var.tags, { "dr" = "true" })
}

# Backup plan with cross-Region copy rule

resource "aws_backup_plan" "plan" {
  name = "${var.prefix}-${var.name}-plan"

  rule {
    rule_name         = "${var.prefix}-${var.name}-daily-rule"
    target_vault_name = aws_backup_vault.source.name
    schedule          = var.schedule_cron_daily
    start_window      = var.start_window_daily
    completion_window = var.completion_window_daily

    lifecycle {
      delete_after = var.delete_after_daily
    }

    copy_action {
      destination_vault_arn = aws_backup_vault.destination.arn

      lifecycle {
        delete_after = var.delete_after_daily
      }
    }
  }
  rule {
    rule_name         = "${var.prefix}-${var.name}-weekly-rule"
    target_vault_name = aws_backup_vault.source.name
    schedule          = var.schedule_cron_weekly
    start_window      = var.start_window_weekly
    completion_window = var.completion_window_weekly

    lifecycle {
      delete_after = var.delete_after_weekly
    }

    copy_action {
      destination_vault_arn = aws_backup_vault.destination.arn

      lifecycle {
        delete_after = var.delete_after_weekly
      }
    }
  }
  rule {
    rule_name         = "${var.prefix}-${var.name}-monthly-rule"
    target_vault_name = aws_backup_vault.source.name
    schedule          = var.schedule_cron_monthly
    start_window      = var.start_window_monthly
    completion_window = var.completion_window_monthly

    lifecycle {
      delete_after = var.delete_after_monthly
    }

    copy_action {
      destination_vault_arn = aws_backup_vault.destination.arn

      lifecycle {
        delete_after = var.delete_after_monthly
      }
    }
  }
  rule {
    rule_name         = "${var.prefix}-${var.name}-yearly-rule"
    target_vault_name = aws_backup_vault.source.name
    schedule          = var.schedule_cron_yearly
    start_window      = var.start_window_yearly
    completion_window = var.completion_window_yearly

    lifecycle {
      delete_after = var.delete_after_yearly
    }

    copy_action {
      destination_vault_arn = aws_backup_vault.destination.arn

      lifecycle {
        delete_after = var.delete_after_yearly
      }
    }
  }

}

# Tag-based resource selection

resource "aws_backup_selection" "tagged" {
  iam_role_arn = aws_iam_role.backup_role.arn
  name         = "${var.prefix}-${var.name}-selection"
  plan_id      = aws_backup_plan.plan.id

  resources = [var.service_arn]
}

resource "aws_iam_role" "backup_role" {
  name = "${var.prefix}-${var.name}-backup-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "backup.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy" "role_policy" {
  name = "${var.prefix}-${var.name}-backup-inline-policy"
  role = aws_iam_role.backup_role.name
  policy = templatefile("${var.policy_path}/backup_service_access_policy.json.tpl", {
    PARTITION = data.aws_partition.current.partition
  })
}

resource "aws_iam_role_policy_attachment" "role_policy_attachment" {
  for_each   = toset(var.backup_policy_arns)
  role       = aws_iam_role.backup_role.name
  policy_arn = each.value #"arn:aws:iam::aws:policy/AWSBackupFullAccess"
}
