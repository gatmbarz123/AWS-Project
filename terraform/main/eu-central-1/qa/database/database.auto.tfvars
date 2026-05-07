rds_aurora = {
  web = {
    engine_version  = "16.4"
    master_username = "postgres"
    azs             = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
    instance_count  = 2
    instance_az     = "eu-central-1a"
  }
}