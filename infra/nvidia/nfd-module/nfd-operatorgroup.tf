terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      # Setting the provider version is a strongly recommended practice
      # version = "..."
    }
  }
  # Provider functions require Terraform 1.8 and later.
  required_version = ">= 1.8.0"
}

resource "kubernetes_manifest" "namespace_openshift_nfd" {
  manifest = {
    "apiVersion" = "v1"
    "kind" = "Namespace"
    "metadata" = {
      "labels" = {
        "name" = "openshift-nfd"
        "openshift.io/cluster-monitoring" = "true"
      }
      "name" = "openshift-nfd"
    }
  }
}

resource "kubernetes_manifest" "operatorgroup_openshift_nfd_openshift_nfd" {
  depends_on = [kubernetes_manifest.namespace_openshift_nfd]
  manifest = {
    "apiVersion" = "operators.coreos.com/v1"
    "kind" = "OperatorGroup"
    "metadata" = {
      "generateName" = "openshift-nfd-"
      "name" = "openshift-nfd"
      "namespace" = "openshift-nfd"
    }
    "spec" = {
      "targetNamespaces" = [
        "openshift-nfd",
      ]
    }
  }
}

resource "kubernetes_manifest" "subscription_openshift_nfd_nfd" {
  depends_on = [kubernetes_manifest.namespace_openshift_nfd]
  manifest = {
    "apiVersion" = "operators.coreos.com/v1alpha1"
    "kind" = "Subscription"
    "metadata" = {
      "name" = "nfd"
      "namespace" = "openshift-nfd"
    }
    "spec" = {
      "channel" = "stable"
      "installPlanApproval" = "Automatic"
      "name" = "nfd"
      "source" = "redhat-operators"
      "sourceNamespace" = "openshift-marketplace"
    }
  }
}

output "nfd_instance_output" {
  value = provider::kubernetes::manifest_decode(file("infra/nvidia/nfd-module/nodefeature-instance.yaml"))
}
