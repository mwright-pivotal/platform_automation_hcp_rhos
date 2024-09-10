resource "kubernetes_manifest" "subscription_openshift_nfd_nfd" {
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
