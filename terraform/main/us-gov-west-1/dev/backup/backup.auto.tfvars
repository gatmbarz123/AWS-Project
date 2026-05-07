# backup_config = {
#   "rds-backup" = {
#     resource_type           = "rds"
#     resource_name           = "dev-usgw1-web-rds-cluster"
#     force_destroy           = false
#     schedule_cron_daily     = "cron(30 1 * * ? *)"
#     start_window_daily      = 60
#     completion_window_daily = 360
#     delete_after_daily      = 30

#     schedule_cron_weekly     = "cron(0 2 ? * 1 *)"
#     start_window_weekly      = 60
#     completion_window_weekly = 360
#     delete_after_weekly      = 180

#     schedule_cron_monthly     = "cron(0 3 1 * ? *)"
#     start_window_monthly      = 60
#     completion_window_monthly = 360
#     delete_after_monthly      = 365

#     schedule_cron_yearly     = "cron(0 4 1 1 ? *)"
#     start_window_yearly      = 60
#     completion_window_yearly = 360
#     delete_after_yearly      = 2555
#   }
#   "s3-projects-backup" = {
#     resource_type           = "s3"
#     resource_name           = "dev-usgw1-example-projects"
#     force_destroy           = false
#     schedule_cron_daily     = "cron(30 1 * * ? *)"
#     start_window_daily      = 60
#     completion_window_daily = 360
#     delete_after_daily      = 30

#     schedule_cron_weekly     = "cron(0 2 ? * 1 *)"
#     start_window_weekly      = 60
#     completion_window_weekly = 360
#     delete_after_weekly      = 180

#     schedule_cron_monthly     = "cron(0 3 1 * ? *)"
#     start_window_monthly      = 60
#     completion_window_monthly = 360
#     delete_after_monthly      = 365

#     schedule_cron_yearly     = "cron(0 4 1 1 ? *)"
#     start_window_yearly      = 60
#     completion_window_yearly = 360
#     delete_after_yearly      = 2555
#   }
# }
region_backup = "us-gov-east-1"
# policy_path   = "../../../common/policies/iam"

# backup_policy_arns = [
#   "arn:aws-us-gov:iam::aws:policy/AWSBackupFullAccess",
#   "arn:aws-us-gov:iam::aws:policy/AmazonS3FullAccess"
# ]
