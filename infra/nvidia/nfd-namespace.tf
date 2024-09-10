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
