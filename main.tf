
provider "null" {}

resource "null_resource" "kibana_action" {
  count = length(var.actions)

  provisioner "local-exec" {
    when    = create
    command = <<EOT
      response=$(curl -X ${var.actions[count.index].http_method} "${var.kibana_endpoint}/s/${var.kibana_space}/${var.actions[count.index].kibana_api}" \
        -H "Content-Type: application/json" \
        -H "Authorization: ApiKey ${var.kibana_api_key}" \
        -H "kbn-xsrf: true" \
        -d '${var.actions[count.index].request_body}')
    EOT
  }
}
