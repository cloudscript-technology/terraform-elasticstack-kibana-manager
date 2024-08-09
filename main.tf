
resource "elasticstack_kibana_action_connector" "opsgenie" {
  count               = var.create_connector ? 1 : 0

  name                = var.connector_name
  connector_type_id   = ".opsgenie"
  space_id            = var.space_id
  config              = jsonencode({
    apiUrl = "${var.opsgenie_api_url}"
  })
  secrets          = jsonencode({
    apiKey = "${var.opsgenie_api_key}"
  })
}


resource "elasticstack_kibana_alerting_rule" "alert" {
  count = var.create_alerts ? length(var.alerts) : 0

  name         = var.alerts[count.index].name
  consumer     = var.alerts[count.index].consumer
  rule_type_id = var.alerts[count.index].rule_type_id
  interval     = var.alerts[count.index].interval
  enabled      = var.alerts[count.index].enabled
  notify_when  = var.alerts[count.index].notify_when

  params = jsonencode(var.alerts[count.index].params)

  dynamic "actions" {
    for_each = var.alerts[count.index].actions
    content {
      id    = actions.value.id
      group = actions.value.group
      params = jsonencode(actions.value.params)
    }
  }

  space_id = var.space_id
  tags     = var.alerts[count.index].tags
}
