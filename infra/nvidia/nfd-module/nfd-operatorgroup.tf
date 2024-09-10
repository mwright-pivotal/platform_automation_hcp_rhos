resource "kubernetes_manifest" "operatorgroup_openshift_nfd_openshift_nfd" {
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
