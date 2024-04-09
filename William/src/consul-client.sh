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
datacenter = "dc1"
data_dir = "/home/ubuntu/consulfile/data"
disable_update_check = true

node_name = "consul-client"

connect {
  enabled = true
}

retry_interval = "20s"

log_level = "DEBUG"
log_file = "/home/ubuntu/consulfile/logs/"
log_rotate_duration = "24h"
log_rotate_max_files = 0

performance {
  raft_multiplier = 1
}' >> /home/ubuntu/consul-client.hcl
