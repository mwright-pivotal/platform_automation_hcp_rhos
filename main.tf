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

resource "kubernetes_manifest" "rook-common" {
  for_each = { for k, v in provider::kubernetes::manifest_decode_multi(file("${path.module}/infra/rook/common.yaml")) : k => v }
  manifest = each.value
}

resource "kubernetes_manifest" "rook-operator-openshift" {
  manifest = provider::kubernetes::manifest_decode(file("${path.module}/infra/rook/operator-openshift.yaml"))
}

resource "kubernetes_manifest" "rook-cluster" {
  manifest = provider::kubernetes::manifest_decode(file("${path.module}/infra/rook/cluster.yaml"))
}

resource "kubernetes_manifest" "rook-filesystem" {
  manifest = provider::kubernetes::manifest_decode(file("${path.module}/infra/rook/filesystem.yaml"))
}

resource "kubernetes_manifest" "rook-toolbox" {
  manifest = provider::kubernetes::manifest_decode(file("${path.module}/infra/rook/toolbox.yaml"))
}

resource "kubernetes_manifest" "rhel9-vm" {
  manifest = provider::kubernetes::manifest_decode(file("${path.module}/apps/vm/basic_rhel9_vm.yaml"))
}

