resource "aws_cloudwatch_metric_alarm" "main" {
  alarm_name          = "${var.prefix}-high-cpu-utilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  datapoints_to_alarm = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 1
  alarm_description   = "このアラームは${var.prefix}-ec2のCPU使用率が1%以上でトリガーされます。"
  dimensions = {
    InstanceId = "${var.ec2_id}"
  }
  alarm_actions = [var.sns_topic]
  #ok_actions                = []
  #insufficient_data_actions = []
  actions_enabled = true

  treat_missing_data = "missing"
}
