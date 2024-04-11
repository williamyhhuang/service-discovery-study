# Specify the Consul provider source and version
terraform {
  required_providers {
    consul = {
      source = "hashicorp/consul"
      version = "2.14.0"
    }
  }
}

# Configure the Consul provider
provider "consul" {
  address    = "localhost:8500"
  datacenter = "dc1"

  # SecretID from the previous step
  #token      = "1148fbd3-a5e9-7946-a9a0-a3f7496cdb0a"
}


### 新增node
# Register external node - counting
resource "consul_node" "counting" {
  name    = "counting"
  address = "localhost"

  meta = {
    "external-node"  = "true"
    "external-probe" = "true"
  }
}

# Register external node - dashboard
resource "consul_node" "dashboard" {
  name    = "dashboard"
  address = "localhost"

  meta = {
    "external-node"  = "true"
    "external-probe" = "true"
  }
}


### 新增service
# Register Counting Service
resource "consul_service" "counting" {
  name    = "counting-service"
  node    = consul_node.counting.name
  port    = 9001
  tags    = ["counting"]

  check {
    check_id                          = "service:counting"
    name                              = "Counting health check"
    #status                            = "passing"
    http                              = "http://counting-service:9001"
    tls_skip_verify                   = false
    method                            = "GET"
    interval                          = "5s"
    timeout                           = "1s"
    deregister_critical_service_after = "30m"
  }
}

# Register Dashboard Service
resource "consul_service" "dashboard" {
  name    = "dashboard-service"
  node    = consul_node.dashboard.name
  port    = 8080
  tags    = ["dashboard"]

  check {
    check_id                          = "service:dashboard"
    name                              = "Dashboard health check"
    #status                            = "passing"
    http                              = "http://dashboard:8080"
    tls_skip_verify                   = false
    method                            = "GET"
    interval                          = "5s"
    timeout                           = "1s"
    deregister_critical_service_after = "30m"
  }
}

# Register Dashboard Service
resource "consul_service" "dashboard-fail" {
  name    = "dashboard-fail-service"
  node    = consul_node.dashboard.name
  port    = 6666
  tags    = ["dashboard"]

  check {
    check_id                          = "service:dashboard-fail"
    name                              = "Dashboard health check"
    #status                            = "passing"
    http                              = "http://dashboard:6666"
    tls_skip_verify                   = false
    method                            = "GET"
    interval                          = "5s"
    timeout                           = "1s"
    deregister_critical_service_after = "30m"
  }
}

# List all services
data "consul_services" "dc1" {}

output "consul_services_dc1" {
    value = data.consul_services.dc1
}
