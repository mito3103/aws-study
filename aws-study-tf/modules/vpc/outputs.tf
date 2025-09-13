output "vpc_id" {
  value = aws_vpc.this.id
}

output "public_subnet_ids" {
  value = [for s in aws_subnet.public : s.id]
}

output "private_subnet_id" {
  value = aws_subnet.private[0].id
}

output "dbsubnetgroup" {
  value = aws_db_subnet_group.this.name
}

output "vpc_cidr_block" {
  value = aws_vpc.this.cidr_block
}

output "pub_subnet_cidr_blocks" {
  value = [for subnet in aws_subnet.public : subnet.cidr_block]
}

output "enable_dns_support" {
  value = aws_vpc.this.enable_dns_support
}
