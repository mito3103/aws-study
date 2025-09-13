output "scope" {
  value = aws_wafv2_web_acl.this.scope
}

output "cw_metrics_enabled" {
  value = aws_wafv2_web_acl.this.visibility_config[0].cloudwatch_metrics_enabled
}

output "rule_metrics_enabled" {
  value = aws_wafv2_web_acl.this.rule
}
