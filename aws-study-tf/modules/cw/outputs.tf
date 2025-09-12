#テスト用
output "comparison_operator" {
  value = aws_cloudwatch_metric_alarm.main.comparison_operator
}

output "statistic" {
  value = aws_cloudwatch_metric_alarm.main.statistic
}
