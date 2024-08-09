variable "kibana_api_key" {
  description = "The API Key for Elasticsearch and Kibana"
  type        = string
  sensitive   = true
}

variable "kibana_endpoint" {
  description = "The Elasticsearch and Kibana endpoint URL"
  type        = string
}

variable "space_id" {
  description = "The Kibana Space ID"
  type        = string
}



variable "create_connector" {
  description = "Whether to create the Opsgenie connector"
  type        = bool
  default     = false
}

variable "connector_name" {
  description = "The name of the Opsgenie connector"
  type        = string
  default     = "opsgenie-connector"
}

variable "opsgenie_api_url" {
  description = "The Opsgenie API URL"
  type        = string
  default     = "https://api.opsgenie.com"
}

variable "opsgenie_api_key" {
  description = "The API key for Opsgenie"
  type        = string
  sensitive   = true
  default     = ""
}

variable "create_alerts" {
  description = "Whether to create the Opsgenie connector"
  type        = bool
  default     = false
}

variable "alerts" {
  description = "A list of alerts to create in Kibana"
  type = list(object({
    name         = string
    consumer     = string
    rule_type_id = string
    interval     = string
    enabled      = bool
    notify_when  = string
    params       = any
    tags         = any
    actions      = list(object({
      id     = string
      group  = string
      params = any
    }))
  }))
}
