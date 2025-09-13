output "ec2_sg" {
  value = aws_security_group.ec2_sg
}

output "rds_sg" {
  value = aws_security_group.rds_sg
}

output "alb_sg" {
  value = aws_security_group.alb_sg
}

#テスト用
output "ec2_sg_rules" {
  value = [
    for rule in [
      aws_vpc_security_group_ingress_rule.public,
      aws_vpc_security_group_ingress_rule.public_ssh
    ] :
    {
      from_port = rule.from_port
      to_port   = rule.to_port
    }
  ]
}

