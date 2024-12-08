resource "kubernetes_manifest" "namespace_rook_ceph" {
  manifest = {
    "apiVersion" = "v1"
    "kind" = "Namespace"
    "metadata" = {
      "name" = "rook-ceph"
    }
  }
}
