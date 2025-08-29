resource "aws_sns_topic" "alerts" {
  name         = "${var.prefix}-cloudwatch-alerts"
  display_name = "${var.prefix}-cloudwatch-alerts"
}

resource "aws_sns_topic_subscription" "this" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = var.email
}
