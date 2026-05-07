rds_aurora = {
  web = {
    engine_version           = "16.8"
    master_username          = "postgres"
    azs                      = ["us-east-1a", "us-east-1b", "us-east-1c"]
    instance_count           = 2
    instance_az              = "us-east-1a"
    secret_rotation_schedule = "cron(0 20 ? * SAT *)"
  }

  web-api = {
    engine_version           = "16.8"
    master_username          = "postgres"
    azs                      = ["us-east-1a", "us-east-1b", "us-east-1c"]
    instance_count           = 2
    instance_az              = "us-east-1a"
    secret_rotation_schedule = "cron(0 20 ? * SAT *)"
  }
}
