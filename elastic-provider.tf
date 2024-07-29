terraform {
  required_providers {
    elasticstack = {
      source  = "elastic/elasticstack"
      version = "0.11.4"
    }
  }
}

provider "elasticstack" {
  kibana {
    api_key  = var.kibana_api_key
    endpoints = ["${var.kibana_endpoint}"]
  }
}
