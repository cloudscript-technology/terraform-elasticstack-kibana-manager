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

variable "actions" {
  description = "List of actions to be created in Kibana"
  type = list(object({
    http_method = string
    kibana_api  = string
    request_body = string
  }))
}
