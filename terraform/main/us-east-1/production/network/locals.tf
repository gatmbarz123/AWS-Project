locals {
  vpc_endpoints = {
    sts = {
      service_name = "com.amazonaws.${var.region}.sts"
      sg_ingress_rules = {
        443 = {
          from_port = 443
          to_port   = 443
          protocol  = "tcp"
        }
      }
    }
  }
}