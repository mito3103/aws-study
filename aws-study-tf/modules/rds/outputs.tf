#テスト用
output "instance_class" {
  value = aws_db_instance.this.instance_class
}

output "db_name" {
  value = aws_db_instance.this.db_name
}

output "publicly_accessible" {
  value = aws_db_instance.this.publicly_accessible
}
