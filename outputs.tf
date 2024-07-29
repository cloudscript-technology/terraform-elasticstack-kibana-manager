output "connector_id" {
  value = var.create_connector ? replace(elasticstack_kibana_action_connector.opsgenie[0].id, "${var.space_id}/", "") : ""
}

output "connector_name" {
  value = var.create_connector ? elasticstack_kibana_action_connector.opsgenie[0].name : ""
}

output "alert_ids" {
  value = var.create_alerts ? [for a in elasticstack_kibana_alerting_rule.alert : a.id] : []
}
