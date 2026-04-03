output "bastion_public_ip"  { value = aws_instance.bastion.public_ip }
output "app_server_id"      { value = aws_instance.app-server.id }
output "app_sg_id" {
  value = aws_security_group.bastion_app_sg[*].id
}