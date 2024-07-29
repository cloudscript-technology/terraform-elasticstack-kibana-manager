output "kibana_action_response" {
  value = jsondecode(file("${path.module}/response.json"))
}
