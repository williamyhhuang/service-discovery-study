provider "aws" {
  region = "ap-northeast-1"
}

# Specify the Consul provider source and version
terraform {
  required_providers {
    consul = {
      source = "hashicorp/consul"
      version = "2.14.0"
    }
  }
}