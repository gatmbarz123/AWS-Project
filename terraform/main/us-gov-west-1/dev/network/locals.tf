locals {
  vpc_endpoints = {
    # postgresql = {
    #   service_name = "com.amazonaws.${var.region}.rds"
    #   subnet_ids   = module.vpc.database_subnets
    #   sg_ingress_rules = {
    #     5432 = {
    #       from_port = 5432
    #       to_port   = 5432
    #       protocol  = "tcp"
    #     }
    #     443 = {
    #       from_port = 443
    #       to_port   = 443
    #       protocol  = "tcp"
    #     }
    #   }
    # }
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
    s3 = {
      service_name        = "com.amazonaws.${var.region}.s3"
      vpc_endpoint_type   = "Gateway"
      private_dns_enabled = false
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
