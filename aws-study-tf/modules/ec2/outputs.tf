output "ec2_id" {
  value = aws_instance.this.id
}

#テスト用
output "instance_type" {
  value = aws_instance.this.instance_type
}
