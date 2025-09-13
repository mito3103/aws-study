output "sns_topic" {
  value = aws_sns_topic.alerts.arn
}

#テスト用
output "sns_protocol" {
  value = aws_sns_topic_subscription.this.protocol
}
