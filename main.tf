terraform {
  required_providers {
    http = {
      source = "hashicorp/http"
      version = "2.1.0"
    }
  }
}

provider "http" {}

resource "http_request" "kibana_action" {
  url = "${var.kibana_endpoint}/s/${var.kibana_space}/${var.kibana_api}"
  method = var.http_method

  request_headers = {
    Content-Type = "application/json"
    Authorization = "ApiKey ${var.kibana_api_key}"
    kbn-xsrf = "true"
  }

  request_body = var.request_body

  lifecycle {
    ignore_changes = [
      request_body
    ]
  }
}
