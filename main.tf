provider "kubernetes" {}

terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.31.0"
    }
  }
}

resource "kubernetes_manifest" "name" {
  manifest = provider::kubernetes::manifest_decode(file("${path.module}/apps/vm/basic_rhel9_vm.yaml"))
}

