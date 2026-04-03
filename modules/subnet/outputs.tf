output "subnet_id" {
  value = aws_subnet.main-subnet[*].id
}

output "public_subnet_id" {
    value = aws_subnet.main-subnet[0].id
}