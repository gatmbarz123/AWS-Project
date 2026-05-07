# resource "aws_kms_key" "backup_destination" {
#   provider                = aws.dr
#   description             = "KMS key for AWS Backup vault in DR region"
#   deletion_window_in_days = 30
#   enable_key_rotation     = true

#   tags = merge(var.tags, {
#     Name = "${var.prefix}-backup-destination-key"
#   })
# }

# resource "aws_kms_alias" "backup_destination" {
#   provider      = aws.dr
#   name          = "alias/${var.prefix}-backup-destination"
#   target_key_id = aws_kms_key.backup_destination.key_id
# }

# module "backup-rds" {
#   source                  = "../../../../modules/storage/backup"
#   prefix                  = var.prefix
#   source_kms_key_arn      = data.aws_kms_alias.backup_source.target_key_arn
#   destination_kms_key_arn = aws_kms_key.backup_destination.arn
#   service_arn             = data.aws_rds_cluster.rds.arn
#   policy_path             = var.policy_path
#   # Pass provider configurations to the module
#   providers = {
#     aws    = aws
#     aws.dr = aws.dr
#   }

#   for_each = var.backup_config

#   name                    = each.key
#   force_destroy           = lookup(each.value, "force_destroy", false)
#   schedule_cron_daily     = lookup(each.value, "schedule_cron_daily", "cron(30 1 * * ? *)")
#   start_window_daily      = lookup(each.value, "start_window_daily", 60)
#   completion_window_daily = lookup(each.value, "completion_window_daily", 360)
#   delete_after_daily      = lookup(each.value, "delete_after_daily", 30)

#   schedule_cron_weekly     = lookup(each.value, "schedule_cron_weekly", "cron(0 2 ? * 1 *)")
#   start_window_weekly      = lookup(each.value, "start_window_weekly", 60)
#   completion_window_weekly = lookup(each.value, "completion_window_weekly", 360)
#   delete_after_weekly      = lookup(each.value, "delete_after_weekly", 180)

#   schedule_cron_monthly     = lookup(each.value, "schedule_cron_monthly", "cron(0 3 1 * ? *)")
#   start_window_monthly      = lookup(each.value, "start_window_monthly", 60)
#   completion_window_monthly = lookup(each.value, "completion_window_monthly", 360)
#   delete_after_monthly      = lookup(each.value, "delete_after_monthly", 365)

#   schedule_cron_yearly     = lookup(each.value, "schedule_cron_yearly", "cron(0 4 1 1 ? *)")
#   start_window_yearly      = lookup(each.value, "start_window_yearly", 60)
#   completion_window_yearly = lookup(each.value, "completion_window_yearly", 360)
#   delete_after_yearly      = lookup(each.value, "delete_after_yearly", 365 * 7)
#   tags                     = var.tags
# }


# resource "aws_kms_key" "backup_destination" {
#   provider                = aws.dr
#   description             = "KMS key for AWS Backup vault in DR region"
#   deletion_window_in_days = 30
#   enable_key_rotation     = true

#   tags = merge(var.tags, {
#     Name = "${var.prefix}-backup-destination-key"
#   })
# }

# resource "aws_kms_alias" "backup_destination" {
#   provider      = aws.dr
#   name          = "alias/${var.prefix}-backup-destination"
#   target_key_id = aws_kms_key.backup_destination.key_id
# }

# #Backup-dev
# module "backup-rds" {
#   source                  = "../../../../modules/storage/backup"
#   prefix                  = var.prefix
#   source_kms_key_arn      = data.aws_kms_alias.backup_source.target_key_arn
#   destination_kms_key_arn = aws_kms_key.backup_destination.arn
#   policy_path             = var.policy_path
#   # Pass provider configurations to the module
#   providers = {
#     aws    = aws
#     aws.dr = aws.dr
#   }

#   backup_policy_arns = var.backup_policy_arns

#   for_each = local.backup_configs_with_arns

#   service_arn             = each.value.service_arn
#   name                    = each.key
#   force_destroy           = lookup(each.value, "force_destroy", false)
#   schedule_cron_daily     = lookup(each.value, "schedule_cron_daily", "cron(30 1 * * ? *)")
#   start_window_daily      = lookup(each.value, "start_window_daily", 60)
#   completion_window_daily = lookup(each.value, "completion_window_daily", 360)
#   delete_after_daily      = lookup(each.value, "delete_after_daily", 30)

#   schedule_cron_weekly     = lookup(each.value, "schedule_cron_weekly", "cron(0 2 ? * 1 *)")
#   start_window_weekly      = lookup(each.value, "start_window_weekly", 60)
#   completion_window_weekly = lookup(each.value, "completion_window_weekly", 360)
#   delete_after_weekly      = lookup(each.value, "delete_after_weekly", 180)

#   schedule_cron_monthly     = lookup(each.value, "schedule_cron_monthly", "cron(0 3 1 * ? *)")
#   start_window_monthly      = lookup(each.value, "start_window_monthly", 60)
#   completion_window_monthly = lookup(each.value, "completion_window_monthly", 360)
#   delete_after_monthly      = lookup(each.value, "delete_after_monthly", 365)

#   schedule_cron_yearly     = lookup(each.value, "schedule_cron_yearly", "cron(0 4 1 1 ? *)")
#   start_window_yearly      = lookup(each.value, "start_window_yearly", 60)
#   completion_window_yearly = lookup(each.value, "completion_window_yearly", 360)
#   delete_after_yearly      = lookup(each.value, "delete_after_yearly", 365 * 7)
#   tags                     = var.tags
# }
