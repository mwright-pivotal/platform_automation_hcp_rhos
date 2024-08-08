provider "kubernetes" {}

locals {
  decoded_yaml = yamldecode(file("${path.module}/apps/vm/basic_rhel9_vm.yaml"))
}

output "VMyaml" {
  value = "${local.decoded_yaml}"
}

resource "kubernetes_manifest" "rhel9_vm" {
  for_each = { for k, v in local.decoded_yaml : k => v }
  manifest = each.value
}
