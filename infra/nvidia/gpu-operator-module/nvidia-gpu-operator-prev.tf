resource "kubernetes_manifest" "namespace_nvidia_gpu_operator" {
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
resource "kubernetes_manifest" "operatorgroup_nvidia_gpu_operator_nvidia_gpu_operator_group" {
  depends_on = [kubernetes_manifest.namespace_nvidia_gpu_operator]
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
resource "kubernetes_manifest" "subscription_nvidia_gpu_operator_gpu_operator_certified" {
  depends_on = [kubernetes_manifest.operatorgroup_nvidia_gpu_operator_nvidia_gpu_operator_group]
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
resource "kubernetes_manifest" "clusterpolicy_gpu_cluster_policy" {
  depends_on = [kubernetes_manifest.subscription_nvidia_gpu_operator_gpu_operator_certified]
  manifest = {
    "apiVersion" = "nvidia.com/v1"
    "kind" = "ClusterPolicy"
    "metadata" = {
      "annotations" = null
      "name" = "gpu-cluster-policy"
    }
    "spec" = {
      "daemonsets" = {
        "rollingUpdate" = {
          "maxUnavailable" = "1"
        }
        "updateStrategy" = "RollingUpdate"
      }
      "dcgm" = {
        "enabled" = true
      }
      "dcgmExporter" = {
        "config" = {
          "name" = ""
        }
        "enabled" = true
        "serviceMonitor" = {
          "enabled" = true
        }
      }
      "devicePlugin" = {
        "config" = {
          "default" = ""
          "name" = ""
        }
        "enabled" = true
      }
      "driver" = {
        "certConfig" = {
          "name" = ""
        }
        "enabled" = true
        "kernelModuleConfig" = {
          "name" = ""
        }
        "licensingConfig" = {
          "configMapName" = ""
          "nlsEnabled" = false
        }
        "repoConfig" = {
          "configMapName" = ""
        }
        "upgradePolicy" = {
          "autoUpgrade" = true
          "drain" = {
            "deleteEmptyDir" = false
            "enable" = false
            "force" = false
            "timeoutSeconds" = 300
          }
          "maxParallelUpgrades" = 1
          "maxUnavailable" = "25%"
          "podDeletion" = {
            "deleteEmptyDir" = false
            "force" = false
            "timeoutSeconds" = 300
          }
          "waitForCompletion" = {
            "timeoutSeconds" = 0
          }
        }
        "virtualTopology" = {
          "config" = ""
        }
      }
      "gfd" = {
        "enabled" = true
      }
      "mig" = {
        "strategy" = "single"
      }
      "migManager" = {
        "enabled" = true
      }
      "nodeStatusExporter" = {
        "enabled" = true
      }
      "operator" = {
        "defaultRuntime" = "crio"
        "initContainer" = {}
        "runtimeClass" = "nvidia"
        "use_ocp_driver_toolkit" = true
      }
      "sandboxDevicePlugin" = {
        "enabled" = true
      }
      "sandboxWorkloads" = {
        "defaultWorkload" = "container"
        "enabled" = false
      }
      "toolkit" = {
        "enabled" = true
        "installDir" = "/usr/local/nvidia"
      }
      "validator" = {
        "plugin" = {
          "env" = [
            {
              "name" = "WITH_WORKLOAD"
              "value" = "true"
            },
          ]
        }
      }
      "vfioManager" = {
        "enabled" = true
      }
      "vgpuDeviceManager" = {
        "enabled" = true
      }
      "vgpuManager" = {
        "enabled" = false
      }
    }
  }
}
