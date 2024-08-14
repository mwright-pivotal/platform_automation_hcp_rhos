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

resource "kubernetes_manifest" "namespace_rook_ceph" {
  manifest = {
    "apiVersion" = "v1"
    "kind" = "Namespace"
    "metadata" = {
      "name" = "rook-ceph"
    }
  }
}

resource "kubernetes_manifest" "rook-common" {
  for_each = { for k, v in provider::kubernetes::manifest_decode_multi(file("${path.module}/infra/rook/common.yaml")) : k => v }
  manifest = each.value
}

resource "kubernetes_manifest" "rook-operator-openshift" {
  for_each = { for k, v in provider::kubernetes::manifest_decode_multi(file("${path.module}/infra/rook/operator-openshift.yaml")) : k => v }
  manifest = each.value
  field_manager {
    # set the name of the field manager
    name = "myteam"

    # force field manager conflicts to be overridden
    force_conflicts = true
  }
}

resource "kubernetes_manifest" "rook-cluster" {
  manifest = provider::kubernetes::manifest_decode(file("${path.module}/infra/rook/cluster.yaml"))
  field_manager {
    # set the name of the field manager
    name = "myteam"

    # force field manager conflicts to be overridden
    force_conflicts = true
  }
}

resource "kubernetes_manifest" "rook-filesystem" {
  for_each = { for k, v in provider::kubernetes::manifest_decode_multi(file("${path.module}/infra/rook/filesystem.yaml")) : k => v }
  manifest = each.value
  field_manager {
    # set the name of the field manager
    name = "myteam"

    # force field manager conflicts to be overridden
    force_conflicts = true
  }
}

resource "kubernetes_manifest" "rook-toolbox" {
  manifest = provider::kubernetes::manifest_decode(file("${path.module}/infra/rook/toolbox.yaml"))
}

resource "kubernetes_manifest" "windows2022-vm" {
  manifest = provider::kubernetes::manifest_decode(file("${path.module}/apps/vm/win2022-vm.yaml"))
}

