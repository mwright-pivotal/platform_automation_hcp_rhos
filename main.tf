provider "kubernetes" {
  host                   = "https://kubernetes.default.svc"
  token = file("/var/run/secrets/kubernetes.io/serviceaccount/token")
  cluster_ca_certificate = file("/var/run/secrets/kubernetes.io/serviceaccount/ca.crt")
}

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

