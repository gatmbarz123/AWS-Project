resource "aws_wafv2_ip_set" "white_list_allowed_ips" {
  name               = "${var.prefix}-allowed-ips"
  scope              = var.waf_ip_set_scope
  description        = "IP set for the ${var.prefix} environment"
  ip_address_version = var.waf_ip_set_addresses_version
  addresses          = var.allowed_ip_addresses

  tags = var.tags
}

#-----------------------------------------------------WAF IP SET ^

#-----------------------------------------------------WAF ACL RULES v


resource "aws_wafv2_web_acl" "waf_acl" {
  name        = "${var.prefix}-waf-acl-regional"
  description = "WAF ACL for the ${var.prefix} environment"
  scope       = var.waf_acl_scope


  # The default action specifies what happens to requests that do not match any rules. 
  # allow =  all unmatched requests are allowed.
  # block =  all unmatched requests are blocked.

  dynamic "default_action" {
    for_each = var.default_action == "allow" ? [1] : []
    content {
      allow {}
    }
  }
  dynamic "default_action" {
    for_each = var.default_action == "block" ? [1] : []
    content {
      block {}
    }
  }

  #----------------------------------------------------------Rules

  dynamic "rule" {
    for_each = var.white_list
    content {
      name     = rule.value.name
      priority = rule.value.priority

      action {
        allow {}
      }

      statement {
        ip_set_reference_statement {
          arn = aws_wafv2_ip_set.white_list_allowed_ips.arn
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = rule.value.cloudwatch_metrics_enabled # true ot false (If you want cloudwatch to metrics after this rule)
        metric_name                = rule.value.metric_name                # The name of the metric rule in the cloudwatch
        sampled_requests_enabled   = rule.value.sampled_requests_enabled   # If true, samples requests for monitoring
      }

    }
  }

  dynamic "rule" {
    for_each = length(var.geo_allow_countries) > 0 ? [1] : []
    content {
      name     = "geo-allow"
      priority = 3

      action {
        allow {}
      }

      statement {
        geo_match_statement {
          country_codes = var.geo_allow_countries
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "geo-allow-metrics"
        sampled_requests_enabled   = true
      }
    }
  }

  dynamic "rule" {
    for_each = var.waf_rules
    content {
      name     = rule.value.name     # The name of the Rule in the waf acl 
      priority = rule.value.priority #  Priority of the rule

      # You need to diside what override action u want to put in the rule
      # none = means the rule takes its default action.
      # count =  means matched requests are counted but not blocked.

      dynamic "override_action" {
        for_each = rule.value.override_action == "none" ? [1] : []
        content {
          none {}
        }
      }

      dynamic "override_action" {
        for_each = rule.value.override_action == "count" ? [1] : []
        content {
          count {}
        }
      }

      statement {
        managed_rule_group_statement {
          name        = rule.value.name        # # The name of the managed rule group 
          vendor_name = rule.value.vendor_name # The vendor = "AWS" 
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = rule.value.cloudwatch_metrics_enabled # true ot false (If you want cloudwatch to metrics after this rule)
        metric_name                = rule.value.metric_name                # The name of the metric rule in the cloudwatch
        sampled_requests_enabled   = rule.value.sampled_requests_enabled   # If true, samples requests for monitoring
      }
    }

  }

  tags = var.tags


  visibility_config {
    cloudwatch_metrics_enabled = var.cloudwatch_metrics_enabled # true ot false (If you want cloudwatch to metrics after this rule)
    metric_name                = var.metric_name                # The name of the metric waf in the cloudwatch
    sampled_requests_enabled   = var.sampled_requests_enabled   # If true, samples requests for monitoring
  }
}


