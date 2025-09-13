output "alb" {
  value = aws_lb.this.arn
}

#テスト用
output "load_balancer_type" {
  value = aws_lb.this.load_balancer_type
}

output "alb_target_port" {
  value = aws_lb_target_group.this.port
}

output "alb_listener_port" {
  value = aws_lb_listener.this.port
}

output "alb_listener_type" {
  value = aws_lb_listener.this.default_action[0].type
}
