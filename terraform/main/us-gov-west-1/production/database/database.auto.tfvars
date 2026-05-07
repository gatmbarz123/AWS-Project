rds_aurora = {
  web = {
    engine_version           = "16.8"
    master_username          = "postgres"
    azs                      = ["us-gov-west-1a", "us-gov-west-1b", "us-gov-west-1c"]
    instance_count           = 2
    instance_az              = "us-gov-west-1a"
    secret_rotation_schedule = "cron(0 20 ? * SAT *)"
    use_serverless           = false
    instance_class           = "db.r6g.xlarge"     # Production-grade instance
    ca_cert_identifier       = "rds-ca-rsa4096-g1" # GovCloud-specific certificate
  }
}
