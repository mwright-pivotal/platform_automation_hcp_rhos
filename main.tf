provider "kubernetes" {
  host                   = "https://kubernetes.default.svc"
  token = file("/var/run/secrets/kubernetes.io/serviceaccount/token")
  cluster_ca_certificate = file("/var/run/secrets/kubernetes.io/serviceaccount/ca.crt")
}

terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.32.0"
    }
  }
}

resource "kubernetes_namespace" "rook-ceph" {
  metadata {
    name = "rook-ceph"
  }
  wait_for_default_service_account = true
}

#module "rook-operator" {
#   source = "./infra/rook"
#   depends_on = [kubernetes_namespace.rook-ceph]
#}

#module "rook-cluster" {
#   source = "./infra/rook/cluster"
#   depends_on = [module.rook-operator.operator]
#}

resource "kubernetes_manifest" "vault" {
  for_each = { for k, v in provider::kubernetes::manifest_decode_multi(file("${path.module}/infra/vault/install.yaml")) : k => v }
  manifest = each.value
  field_manager {
    # set the name of the field manager
    name = "myteam"

    # force field manager conflicts to be overridden
    force_conflicts = true
  }
}

resource "kubernetes_manifest" "windows2022-vm-import" {
  manifest = provider::kubernetes::manifest_decode(file("${path.module}/apps/vm/dv_windows_2022.yml"))
}
resource "kubernetes_manifest" "windows2022-vm" {
  manifest = provider::kubernetes::manifest_decode(file("${path.module}/apps/vm/win2022-vm.yml"))
}

module "ai-workspace-mike" {
   source = "./apps/ai"
}
