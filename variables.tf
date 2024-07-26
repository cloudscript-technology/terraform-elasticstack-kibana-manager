variable "kibana_endpoint" {
  description = "The Kibana endpoint URL"
  type        = string
}

variable "kibana_api_key" {
  description = "The API key for Kibana"
  type        = string
  sensitive   = true
}

variable "kibana_space" {
  description = "The Kibana space where the action will be performed"
  type        = string
}

variable "kibana_api" {
  description = "The specific API to call within the Kibana space (e.g., api/actions/connector)"
  type        = string
}

variable "http_method" {
  description = "The HTTP method to use for the request (e.g., POST, PUT)"
  type        = string
}

variable "request_body" {
  description = "The JSON body of the request"
  type        = string
}