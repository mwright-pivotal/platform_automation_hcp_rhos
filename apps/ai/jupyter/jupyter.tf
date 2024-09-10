resource "kubernetes_manifest" "service_jupyter_notebook" {
  manifest = {
    "apiVersion" = "v1"
    "kind" = "Service"
    "metadata" = {
      "labels" = {
        "app" = "jupyter-notebook"
      }
      "name" = "jupyter-notebook"
      "namespace" = "default"
    }
    "spec" = {
      "ports" = [
        {
          "name" = "http"
          "nodePort" = 30001
          "port" = 80
          "targetPort" = 8888
        },
      ]
      "selector" = {
        "app" = "jupyter"
      }
      "type" = "NodePort"
    }
  }
}

resource "kubernetes_manifest" "pod_jupyter" {
  manifest = {
    "apiVersion" = "v1"
    "kind" = "Pod"
    "metadata" = {
      "labels" = {
        "app" = "jupyter"
      }
      "name" = "jupyter"
      "namespace" = "default"
    }
    "spec" = {
      "containers" = [
        {
          "image" = "quay.io/jupyter/tensorflow-notebook:cuda-latest"
          "name" = "jupyter"
          "ports" = [
            {
              "containerPort" = 8888
              "name" = "notebook"
            },
          ]
          "resources" = {
            "limits" = {
              "nvidia.com/gpu" = 1
            }
          }
        },
      ]
      "securityContext" = {
        "fsGroup" = 0
      }
    }
  }
}
