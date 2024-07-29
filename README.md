
# terraform-kibana-manager

![Static Badge](https://img.shields.io/badge/Kibana_Manager-0.1.0-blue)
![License](https://img.shields.io/github/license/cloudscript-technology/terraform-kibana-manager.svg)
![GitHub Release](https://img.shields.io/github/release/cloudscript-technology/terraform-kibana-manager.svg)

## Description

This Terraform module allows you to create and manage connectors and alerts in Kibana using the `elasticstack` provider. It offers various configuration options through input variables to customize the creation and management of these resources as needed.

## Features

- Creation of connectors in Kibana
- Configuration of alerts in Kibana
- Support for specifying Kibana spaces

## Usage

### Requirements

- [Terraform](https://www.terraform.io/downloads.html) >= 0.14
- Kibana instance with API access

### Providers

```hcl
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
    endpoint = var.kibana_endpoint
  }
}
```

### Example Configuration

#### Create Opsgenie Connector

```hcl
module "create_opsgenie_connector" {
  source            = "./modules/kibana_manager"
  kibana_endpoint   = var.kibana_endpoint
  kibana_api_key    = var.kibana_api_key
  space_id          = var.space_id
  create_connector  = true
  connector_name    = "Opsgenie Connector"
  opsgenie_api_url  = "https://api.opsgenie.com"
  opsgenie_api_key  = var.opsgenie_api_key
}
```

#### Create Alert

```hcl
module "create_alert" {
  source            = "./modules/kibana_manager"
  kibana_endpoint   = var.kibana_endpoint
  kibana_api_key    = var.kibana_api_key
  space_id          = var.space_id

  create_connector  = false
  create_alerts     = true

  alerts = [
    {
      name         = "[App] [Staging] [SRE] 🚨 Critical: Application Error 504 Rate Surge"
      consumer     = "infrastructure"
      rule_type_id = "observability.rules.custom_threshold"
      interval     = "2m"
      enabled      = true
      notify_when  = "onActionGroupChange"
      params       = {
        criteria = [
          {
            comparator = "<"
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
        alertOnNoData           = false
        alertOnGroupDisappear   = true
        searchConfiguration = {
          query = {
            query    = "http.response.status_code : 504"
            language = "kuery"
          }
          index = "apm_static_data_view_id-staging"
        }
        groupBy = ["service.name", "service.environment", "transaction.name"]
      }
      actions = [
        {
          id    = module.create_opsgenie_connector.connector_id
          group = "custom_threshold.fired"
          params = {
            subAction = "createAlert"
            subActionParams = {
              alias       = "{{rule.id}}:service-name"
              tags        = ["{{rule.tags}}"]
              message     = "[App] [Staging] [SRE] [P1]: Application Error 504 Rate Surge - service-name"
              description = "📈 Threshold: {{context.threshold}} errors over the last {{context.interval}}\n🌐 Ambiente: {{context.service.environment}}\n\n📌 Ação Sugerida:\n1. Verificar os logs da aplicação para identificar a causa raiz dos erros.\n2. Conferir a disponibilidade dos serviços dependentes (bancos de dados, APIs externas).\n3. Realizar um rollback se um deploy recente for suspeito.\n\n📋 Comentários Adicionais:\n- Observe se há padrões nos tipos de erros relatados."
              entity      = "service-name"
              source      = "{{context.alertDetailsUrl}}"
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
      ]
      tags = ["gateway-staging", "elastic-apm", "Responders: CloudScript"]
    }
  ]

}
```

### Variables

| Name              | Type   | Description                                                                                               | Default                      | Required |
|-------------------|--------|-----------------------------------------------------------------------------------------------------------|------------------------------|----------|
| `kibana_endpoint` | string | The Kibana endpoint URL                                                                                   | n/a                          | yes      |
| `kibana_api_key`  | string | The API key for Kibana                                                                                    | n/a                          | yes      |
| `space_id`        | string | The Kibana space where the action will be performed                                                       | n/a                          | yes      |
| `create_connector`| bool   | Whether to create the Opsgenie connector                                                                  | false                        | no       |
| `connector_name`  | string | The name of the Opsgenie connector                                                                        | "opsgenie-connector"         | no       |
| `opsgenie_api_url`| string | The Opsgenie API URL                                                                                      | "https://api.opsgenie.com"   | no       |
| `opsgenie_api_key`| string | The API key for Opsgenie                                                                                  | n/a                          | yes      |
| `create_alerts`   | bool   | Whether to create the alerts                                                                              | false                        | no       |
| `alerts`          | list   | A list of alerts to create in Kibana. Each alert includes name, consumer, rule_type_id, interval, params, actions | n/a                          | yes      |

### Outputs

| Name             | Description                                      |
|------------------|--------------------------------------------------|
| `connector_id`   | The ID of the created Opsgenie connector         |
| `connector_name` | The name of the created Opsgenie connector       |
| `alert_ids`      | The IDs of the created alerts                    |

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
