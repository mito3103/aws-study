resource "aws_wafv2_web_acl" "this" {
  name        = "${var.prefix}-waf"
  description = "WAF for ALB"
  scope       = "REGIONAL"
  default_action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.prefix}-waf"
    sampled_requests_enabled   = true
  }

  rule {
    name     = "common-ruleset"
    priority = 1

    override_action {
      none {}
    }
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesCommonRuleSet"
      sampled_requests_enabled   = true
    }
  }
}

resource "aws_wafv2_web_acl_association" "alb_asso" {
  resource_arn = var.alb
  web_acl_arn  = aws_wafv2_web_acl.this.arn
}

#data "aws_caller_identity" "current" {} #今回は必要無いが汎用性を持たせるために必要

#WAFがCWへ記録するロール
resource "aws_iam_role" "this" {
  name = "aws-waf-logging-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "waf.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "this" {
  name = "waf-logging-policy"
  role = aws_iam_role.this.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"
        ]
        Resource = "${aws_cloudwatch_log_group.waf_logs.arn}:*"
      }
    ]
  })
}

resource "aws_wafv2_web_acl_logging_configuration" "this" {
  log_destination_configs = [aws_cloudwatch_log_group.waf_logs.arn]
  resource_arn            = aws_wafv2_web_acl.this.arn

  logging_filter {
    default_behavior = "KEEP"

    filter {
      behavior    = "DROP"
      requirement = "MEETS_ALL"

      condition {
        action_condition {
          action = "ALLOW"
        }
      }
    }

    filter {
      behavior    = "KEEP"
      requirement = "MEETS_ANY"

      condition {
        action_condition {
          action = "BLOCK"
        }
      }
    }
  }

  redacted_fields {
    single_header {
      name = "authorization"
    }
  }
}


#ロググループ
resource "aws_cloudwatch_log_group" "waf_logs" {
  name              = "aws-waf-logs-${var.prefix}-testlogs"
  retention_in_days = 1
  lifecycle {
    prevent_destroy       = false #学習用のためfalseにしている
    create_before_destroy = true
  }
}

