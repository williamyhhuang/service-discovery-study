provider "consul" {
  address    = "${aws_instance.ec2_instance_server[0].public_ip}:8500"
  datacenter = "dc1"
}

# ec2 - server
resource "aws_instance" "ec2_instance_server" {
  count         = 1
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name      = "aws_keys_pairs"
  vpc_security_group_ids = [aws_security_group.security_group.id]

  user_data = "${file("consul-server.sh")}"

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("${path.module}/aws_keys_pairs.pem")
    host        = "${local.my_public_ip}"
  }

  tags = {
    Name = "consul-instance-server-${count.index}"
  }
}

# ec2 - client
resource "aws_instance" "ec2_instance_client" {
  count         = 2
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name      = "aws_keys_pairs"
  vpc_security_group_ids = [aws_security_group.security_group.id]

  user_data = "${file("consul-client.sh")}"

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("${path.module}/aws_keys_pairs.pem")
    host        = "${local.my_public_ip}"
  }

  tags = {
    Name = "consul-instance-client-${count.index}"
  }
}

# # 啟動 consul - server
resource "null_resource" "execute_commands_server" {
  depends_on = [aws_instance.ec2_instance_server, aws_security_group.security_group, aws_key_pair.generated_key]

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = tls_private_key.terrafrom_generated_private_key.private_key_pem  # Use your private key
    host        = aws_instance.ec2_instance_server[0].public_ip
  }

  provisioner "remote-exec" {
    inline = [
         "sudo sleep 30"
        ,"sudo systemctl daemon-reload"
        ,"sudo systemctl start consul"
        ,"sudo systemctl start consul-esm"
        ,"sudo sleep 30"
    ]
  }
}

# 啟動 consul - client
resource "null_resource" "execute_commands_client1" {
  depends_on = [aws_instance.ec2_instance_client, aws_security_group.security_group, aws_key_pair.generated_key]

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = tls_private_key.terrafrom_generated_private_key.private_key_pem  # Use your private key
    host        = aws_instance.ec2_instance_client[0].public_ip
  }

  provisioner "remote-exec" {
    inline = [
        "sudo apt install -y nginx"
        ,"sudo systemctl start nginx"
        ,"sudo systemctl enable nginx"
    ]
  }
}

resource "null_resource" "execute_commands_client2" {
  depends_on = [aws_instance.ec2_instance_client, aws_security_group.security_group, aws_key_pair.generated_key]

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = tls_private_key.terrafrom_generated_private_key.private_key_pem  # Use your private key
    host        = aws_instance.ec2_instance_client[1].public_ip
  }

  provisioner "remote-exec" {
    inline = [
        "sudo apt install -y nginx"
        ,"sudo systemctl start nginx"
        ,"sudo systemctl enable nginx"
    ]
  }
}