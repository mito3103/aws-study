
output "vpc_id" {
  value = aws_vpc.awsstudytfvpc.id
}

output "public_subnet_id" {
  value = aws_subnet.awsstudytfpublicsubnet[0].id
}

