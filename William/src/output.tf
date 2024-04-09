# output ec2 public IP
output "ec2_public_ip_server" {
  value = aws_instance.ec2_instance_server[0].public_ip
}

output "ec2_public_ip_client_1" {
  value = aws_instance.ec2_instance_client[0].public_ip
}

output "ec2_public_ip_client_2" {
  value = aws_instance.ec2_instance_client[1].public_ip
}