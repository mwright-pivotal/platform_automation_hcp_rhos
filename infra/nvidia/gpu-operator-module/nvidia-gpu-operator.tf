resource "kubernetes_operator" "namespace_nvidia_gpu_operator" {
  manifest = {
    "apiVersion" = "v1"
    "kind" = "Namespace"
    "metadata" = {
      "labels" = {
        "name" = "nvidia-gpu-operator"
        "openshift.io/cluster-monitoring" = "true"
      }
      "name" = "nvidia-gpu-operator"
    }
  }
}
resource "kubernetes_operator_group" "operatorgroup_nvidia_gpu_operator_nvidia_gpu_operator_group" {
  depends_on = [kubernetes_operator.namespace_nvidia_gpu_operator]
  manifest = {
    "apiVersion" = "operators.coreos.com/v1"
    "kind" = "OperatorGroup"
    "metadata" = {
      "name" = "nvidia-gpu-operator-group"
      "namespace" = "nvidia-gpu-operator"
    }
    "spec" = {
      "targetNamespaces" = [
        "nvidia-gpu-operator",
      ]
    }
  }
}
resource "kubernetes_subscription" "subscription_nvidia_gpu_operator_gpu_operator_certified" {
  depends_on = [kubernetes_operator_group.operatorgroup_nvidia_gpu_operator_nvidia_gpu_operator_group]
  manifest = {
    "apiVersion" = "operators.coreos.com/v1alpha1"
    "kind" = "Subscription"
    "metadata" = {
      "name" = "gpu-operator-certified"
      "namespace" = "nvidia-gpu-operator"
    }
    "spec" = {
      "channel" = "v22.9"
      "installPlanApproval" = "Automatic"
      "name" = "gpu-operator-certified"
      "source" = "certified-operators"
      "sourceNamespace" = "openshift-marketplace"
      "startingCSV" = "gpu-operator-certified.v22.9.0"
    }
  }
}
