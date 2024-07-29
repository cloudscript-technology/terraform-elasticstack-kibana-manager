
# terraform-kibana-manager

![Static Badge](https://img.shields.io/badge/Kibana_Manager-0.1.0-blue)
![License](https://img.shields.io/github/license/cloudscript-technology/terraform-kibana-manager.svg)
![GitHub Release](https://img.shields.io/github/release/cloudscript-technology/terraform-kibana-manager.svg)

## Description

This Terraform module allows you to create and manage connectors, alerts, and SLOs in Kibana using the `null` provider. It offers various configuration options through input variables to customize the creation and management of these resources as needed.

## Features

- Creation of connectors in Kibana
- Configuration of alerts in Kibana
- Setup of SLOs (Service Level Objectives) in Kibana
- Support for specifying Kibana spaces

## Usage

### Requirements

- [Terraform](https://www.terraform.io/downloads.html) >= 0.14
- Kibana instance with API access

### Providers

```hcl
provider "null" {}
```

### Example Configuration

#### Create Opsgenie Connector

```hcl
module "create_opsgenie_connector" {
  source            = "./modules/kibana_manager"
  kibana_endpoint   = var.kibana_endpoint
  kibana_api_key    = var.kibana_api_key
  kibana_space      = var.kibana_space

  actions = [
    {
      http_method  = "POST"
      kibana_api   = "api/actions/connector"
      request_body = jsonencode({
        name = "Opsgenie Connector",
        connector_type_id = ".opsgenie",
        config = {
          apiUrl = "https://api.opsgenie.com"
        },
        secrets = {
          apiKey = var.opsgenie_api_key
        }
      })
    }
  ]
}
```

#### Create Alert

```hcl
module "create_alert" {
  source            = "./modules/kibana_manager"
  kibana_endpoint   = var.kibana_endpoint
  kibana_api_key    = var.kibana_api_key
  kibana_space      = var.kibana_space

  actions = [
    {
      http_method  = "POST"
      kibana_api   = "api/alerting/rule"
      request_body = jsonencode({
        name = "[App] [Production] 🚨 Critical: High API Latency",
        consumer = "alerts",
        producer = "apm",
        alertTypeId = "apm.transaction_duration",
        params = {
          environment = "production",
          serviceName = "*",
          aggregationType = "avg",
          threshold = 500,
          windowSize = 5,
          windowUnit = "m",
          groupBy = ["service.name", "service.environment", "transaction.type"]
        },
        schedule = {
          interval = "2m"
        },
        tags = ["apm"],
        actions = [{
          group = "threshold_met",
          id = "6b9bffa8-5fbb-457e-a7f3-714396ccd094",
          params = {
            subAction = "createAlert",
            subActionParams = {
              alias = "{{rule.id}}:{{alert.id}}",
              tags = ["{{rule.tags}}"],
              message = "[App] [Production] 🚨 Critical: High API Latency",
              description = "📊 Nome da Transação: {{context.transactionName}}\n📈 Threshold: {{context.threshold}} over the last {{context.interval}}\n🌐 Ambiente: {{context.environment}}\n🔗 URL de Detalhes: [Link]({{context.alertDetailsUrl}})\n\n📌 Ação Sugerida:\n1. Verificar os logs da aplicação para identificar possíveis causas de alta latência.\n2. Conferir o uso de recursos da infraestrutura (CPU, memória).\n3. Analisar o código da transação para otimizações possíveis.\n\n📋 Comentários Adicionais:\n- Verifique se há algum deploy recente ou mudança na infraestrutura.",
              entity = "{{context.serviceName}}",
              source = "{{rule.url}}"
            }
          },
          frequency = {
            notify_when = "onActionGroupChange",
            throttle = null,
            summary = false
          }
        }]
      })
    }
  ]
}
```

#### Create SLO

```hcl
module "create_slo" {
  source            = "./modules/kibana_manager"
  kibana_endpoint   = var.kibana_endpoint
  kibana_api_key    = var.kibana_api_key
  kibana_space      = var.kibana_space

  actions = [
    {
      http_method  = "POST"
      kibana_api   = "api/observability/slos"
      request_body = jsonencode({
        name = "[App] [Production] ⏱️ SLO: Response Time < 250ms",
        description = "Indica que 95% das requisições à core-api no ambiente de produção devem ter um tempo de resposta inferior a 250ms.",
        indicator = {
          type = "sli.apm.transactionDuration",
          params = {
            service = "core-api",
            environment = "production",
            transactionType = "request",
            transactionName = "*",
            threshold = 250,
            filter = "",
            index = "*apm*core-production*"
          }
        },
        budgetingMethod = "occurrences",
        timeWindow = {
          duration = "7d",
          type = "rolling"
        },
        objective = {
          target = 0.95
        },
        tags = ["core-api", "response-time", "production"]
      })
    }
  ]

}
```

### Variables

| Name              | Type   | Description                                                                                               | Default                      | Required |
|-------------------|--------|-----------------------------------------------------------------------------------------------------------|------------------------------|----------|
| `kibana_endpoint` | string | The Kibana endpoint URL                                                                                   | n/a                          | yes      |
| `kibana_api_key`  | string | The API key for Kibana                                                                                    | n/a                          | yes      |
| `kibana_space`    | string | The Kibana space where the action will be performed                                                       | n/a                          | yes      |
| `actions`         | list   | List of actions to be created in Kibana. Each action includes `http_method`, `kibana_api`, and `request_body` | n/a                          | yes      |


### Outputs

| Name                        | Description                                |
|-----------------------------|--------------------------------------------|
| `kibana_action_response`    | The response body of the Kibana action     |

## Contributions

Contributions are welcome! To contribute, follow these steps:

1. Fork this repository
2. Create a branch for your feature (`git checkout -b feature/new-feature`)
3. Commit your changes (`git commit -am 'Add new feature'`)
4. Push to the branch (`git push origin feature/new-feature`)
5. Create a new Pull Request

## License

This project is licensed under the Apache 2.0 License - see the [LICENSE](LICENSE) file for details.

## Author

This module is maintained by [CloudScript Technology](https://github.com/cloudscript-technology).

## References

- [Kibana API Documentation](https://www.elastic.co/guide/en/kibana/current/api.html)
- [Terraform Documentation](https://www.terraform.io/docs)
- [Opsgenie API Documentation](https://docs.opsgenie.com/docs/api-overview)

