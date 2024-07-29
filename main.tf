provider "null" {}

resource "null_resource" "kibana_action" {
  provisioner "local-exec" {
    command = <<EOT
      curl -X ${var.http_method} "${var.kibana_endpoint}/s/${var.kibana_space}/${var.kibana_api}" \
        -H "Content-Type: application/json" \
        -H "Authorization: ApiKey ${var.kibana_api_key}" \
        -H "kbn-xsrf: true" \
        -d '${var.request_body}' -o response.json
    EOT
  }

  provisioner "local-exec" {
    when    = destroy
    command = "rm -f response.json"
  }
}

resource "local_file" "response" {
  content  = file("response.json")
  filename = "${path.module}/response.json"
}
