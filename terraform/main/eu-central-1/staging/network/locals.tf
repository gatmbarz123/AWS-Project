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
    secret_manager = {
      service_name = "com.amazonaws.${var.region}.secretsmanager"
      sg_ingress_rules = {
        443 = {
          from_port = 443
          to_port   = 443
          protocol  = "tcp"
        }
      }
    }
    ecr = {
      service_name = "com.amazonaws.${var.region}.ecr.dkr"
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