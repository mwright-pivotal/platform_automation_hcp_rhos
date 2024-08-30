resource "kubernetes_manifest" "service_ultralytics_notebook" {
  manifest = {
    "apiVersion" = "v1"
    "kind" = "Service"
    "metadata" = {
      "labels" = {
        "app" = "ultralytics-notebook"
      }
      "name" = "ultralytics-notebook"
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
        "app" = "ultralytics"
      }
      "type" = "NodePort"
    }
  }
}

resource "kubernetes_manifest" "pod_ultralyticsa" {
  manifest = {
    "apiVersion" = "v1"
    "kind" = "Pod"
    "metadata" = {
      "labels" = {
        "app" = "ultralytics"
      }
      "name" = "ultralyticsa"
      "namespace" = "default"
    }
    "spec" = {
      "containers" = [
        {
          "image" = "quay.io/jupyter/tensorflow-notebook:cuda-latest"
          "name" = "ultralytics"
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
