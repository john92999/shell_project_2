output "subnet_id" {
  value = aws_subnet.main-subnet[*].id
}