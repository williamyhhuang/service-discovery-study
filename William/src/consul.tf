# Register external node - nginx_1
resource "consul_node" "nginx_1" {
  depends_on = [aws_instance.ec2_instance_server, aws_instance.ec2_instance_client, aws_security_group.security_group, aws_key_pair.generated_key,
  null_resource.execute_commands_server, 
  null_resource.execute_commands_client1]
  name    = "nginx_1"
  address = aws_instance.ec2_instance_client[0].public_ip

  meta = {
    "external-node"  = "true"
    "external-probe" = "true"
  }
}

# Register external node - nginx_2
resource "consul_node" "nginx_2" {
  depends_on = [aws_instance.ec2_instance_server, aws_instance.ec2_instance_client, aws_security_group.security_group, aws_key_pair.generated_key, 
  null_resource.execute_commands_server, 
  null_resource.execute_commands_client2]
  name    = "nginx_2"
  address = aws_instance.ec2_instance_client[1].public_ip

  meta = {
    "external-node"  = "true"
    "external-probe" = "true"
  }
}

# Register nginx_1 Service
resource "consul_service" "nginx_1" {
  name    = "nginx_1-service"
  node    = consul_node.nginx_1.name
  port    = 80
  tags    = ["nginx_1"]

  check {
    check_id                          = "service:nginx_1"
    name                              = "nginx_1 health check"
    status                            = "passing"
    tcp                               = "${aws_instance.ec2_instance_client[0].public_ip}:80"
    tls_skip_verify                   = true
    method                            = "GET"
    interval                          = "5s"
    timeout                           = "1s"
    deregister_critical_service_after = "30s"
  }
}

# Register nginx_2 Service
resource "consul_service" "nginx_2" {
  name    = "nginx_2-service"
  node    = consul_node.nginx_2.name
  port    = 80
  tags    = ["nginx_2"]

  check {
    check_id                          = "service:nginx_2"
    name                              = "nginx_2 health check"
    status                            = "passing"
    tcp                              = "${aws_instance.ec2_instance_client[1].public_ip}:80"
    tls_skip_verify                   = true
    method                            = "GET"
    interval                          = "5s"
    timeout                           = "1s"
    deregister_critical_service_after = "30s"
  }
}