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

resource "kubernetes_manifest" "windows2022-vm-import" {
  manifest = provider::kubernetes::manifest_decode(file("${path.module}/apps/vm/dv_windows_2022.yml"))
}
resource "kubernetes_manifest" "windows2022-vm" {
  manifest = provider::kubernetes::manifest_decode(file("${path.module}/apps/vm/win2022-vm.yml"))
}
resource "kubernetes_manifest" "windows2019-sqlserver-vm-import" {
  manifest = provider::kubernetes::manifest_decode(file("${path.module}/apps/vm/dv_windows_2019_sqlserver.yml"))
}
resource "kubernetes_manifest" "windows2019-sqlserver-vm" {
  manifest = provider::kubernetes::manifest_decode(file("${path.module}/apps/vm/win2019-sqlserver-vm.yaml"))
}
