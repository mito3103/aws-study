output "vpc_id" {
  value = aws_vpc.this.id
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "private_subnet_id" {
  value = aws_subnet.private[0].id
}

output "dbsubnetgroup" {
  value = aws_db_subnet_group.this.name
}

