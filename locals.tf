locals {
  default_alert = {
    consumer     = "infrastructure"
    rule_type_id = "observability.rules.custom_threshold"
    interval     = "2m"
    enabled      = true
    notify_when  = "onActionGroupChange"
  }

  default_params = {
    alertOnNoData         = false
    alertOnGroupDisappear = false
    criteria = [
      {
        comparator = ">="
        metrics    = [
          {
            name    = "A"
            aggType = "count"
          }
        ]
        threshold = [1]
        timeSize  = 5
        timeUnit  = "m"
      }
    ]
    searchConfiguration = {
      query = {
        language = "kuery"
      }
      index        = "apm_static_data_view_id_payments-staging"
    }
  }

  default_action_params = {
    subAction = "createAlert"
    subActionParams = {
      alias       = "{{rule.id}}:{{context.group}}"
      tags        = ["{{rule.tags}}"]
      priority    = "P1"
      responders  = [
        {
          name = "CloudScript"
          type = "team"
        }
      ]
    }
  }
}