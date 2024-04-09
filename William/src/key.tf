# 建立 EC2 所用的公私鑰
# 建立 TLS 私鑰
resource "tls_private_key" "terrafrom_generated_private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {  
  key_name   = "aws_keys_pairs"
  
  # 公鑰
  public_key = tls_private_key.terrafrom_generated_private_key.public_key_openssh
 
  # 私鑰
  # 把它儲存起來，terraform 跑完後可以 SSH 連線至 EC2 驗證
  provisioner "local-exec" {   
    command = "echo '${tls_private_key.terrafrom_generated_private_key.private_key_pem}' > aws_keys_pairs.pem | chmod 400 aws_keys_pairs.pem"
  }
}