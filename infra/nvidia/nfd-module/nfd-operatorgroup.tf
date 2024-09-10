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
  depends_on = ["kubernetes_manifest.namespace_openshift_nfd"]
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
  depends_on = ["kubernetes_manifest.namespace_openshift_nfd"]
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
