#!/bin/bash

echo '
server {
    listen       8080 default_server;
    server_name  localhost;

    location / {
        return 200 'healthy';
    }
}
' >> /etc/nginx/conf.d/http.conf

echo '
server = true
bootstrap_expect = 1
ui_config { 
  enabled = true
}
datacenter = "dc1"
data_dir = "/home/ubuntu/consulfile/data"
disable_update_check = true
enable_local_script_checks = true

client_addr = "0.0.0.0"
bind_addr = "0.0.0.0"

node_name = "consul-server"

connect {
  enabled = true
}

log_level = "DEBUG"
log_file = "/home/ubuntu/consulfile/logs/"
log_rotate_duration = "24h"
log_rotate_max_files = 0
' >> /home/ubuntu/consul-server.hcl

echo '
external_node_meta {
    "external-node" = "true"
    "external-probe" = "true"
}
http_addr = "0.0.0.0:8500"
' >> /home/ubuntu/consul-esm.hcl

echo '
[Unit]
Description=Consul Agent
Requires=network-online.target
After=network-online.target

[Service]
Restart=on-failure
ExecStart=/usr/local/bin/consul agent -config-dir=/home/ubuntu/consul-server.hcl
ExecReload=/usr/local/bin/consul reload
KillSignal=SIGINT
TimeoutStopSec=5

[Install]
WantedBy=multi-user.target
' >> /etc/systemd/system/consul.service

echo '
[Unit]
Description=Consul-esm
Requires=network-online.target
After=network-online.target

[Service]
Restart=on-failure
ExecStart=/usr/local/bin/consul-esm -config-file=/home/ubuntu/consul-esm.hcl &
ExecReload=/usr/local/bin/consul-esm reload
KillSignal=SIGINT
TimeoutStopSec=5

[Install]
WantedBy=multi-user.target
' >> /etc/systemd/system/consul-esm.service

mkdir -p /home/ubuntu/consulfile/logs/
apt install unzip
apt install -y nginx
systemctl start nginx
systemctl enable nginx
wget https://releases.hashicorp.com/consul/1.10.3/consul_1.10.3_linux_amd64.zip
wget https://releases.hashicorp.com/consul-esm/0.7.1/consul-esm_0.7.1_linux_amd64.zip
unzip -qq consul_1.10.3_linux_amd64.zip
unzip -qq consul-esm_0.7.1_linux_amd64.zip
mv consul /usr/local/bin/
mv consul-esm /usr/local/bin/

mkdir -p /home/ubuntu/consulfile/logs/