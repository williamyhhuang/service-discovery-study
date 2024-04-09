locals {
  my_public_ip = jsondecode(data.http.public_ip.response_body).ip
}

# public IP
data "http" "public_ip" {
  url = "http://api.ipify.org?format=json"
}