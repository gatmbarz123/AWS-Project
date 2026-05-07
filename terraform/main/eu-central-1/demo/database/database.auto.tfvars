rds_aurora = {
  web = {
    engine_version           = "16.8"
    master_username          = "postgres"
    azs                      = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
    instance_count           = 2
    instance_az              = "eu-central-1a"
    secret_rotation_schedule = "cron(0 20 ? * SAT *)"
  }
}
