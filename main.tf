provider "kubernetes" {}

locals {
  decoded_yaml = yamldecode(file("${path.module}/apps/vm/basic_rhel9_vm.yaml"))
}

resource "kubernetes_manifest" "rhel9_vm" {
  for_each = { for k, v in local.decoded_yaml : k => v }
  manifest = each.value
}
