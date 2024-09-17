resource "kubernetes_manifest" "service_pgvector_db" {
  manifest = {
    "apiVersion" = "v1"
    "kind" = "Service"
    "metadata" = {
      "labels" = {
        "app" = "pgvector"
      }
      "name" = "pgvector-db"
      "namespace" = "default"
    }
    "spec" = {
      "ports" = [
        {
          "name" = "tcp"
          "nodePort" = 30432
          "port" = 5432
          "targetPort" = 5432
        },
      ]
      "selector" = {
        "app" = "pgvector"
      }
      "type" = "NodePort"
    }
  }
}

resource "kubernetes_manifest" "pod_pgvector" {
  manifest = {
    "apiVersion" = "v1"
    "kind" = "Pod"
    "metadata" = {
      "labels" = {
        "app" = "pgvector"
      }
      "name" = "pgvector"
      "namespace" = "default"
    }
    "spec" = {
      "containers" = [
        {
          "env" = [
            {
              "name" = "POSTGRESQL_PASSWORD"
              "value" = "mike"
            },
          ]
          "image" = "mwrightpivotal/pgvector:1.0"
          "name" = "pgvector"
          "ports" = [
            {
              "containerPort" = 5432
              "name" = "postgresql"
            },
          ]
          "securityContext" = {
            "allowPrivilegeEscalation" = false
            "capabilities" = {
              "drop" = [
                "ALL",
              ]
              "privileged" = false
              "readOnlyRootFilesystem" = true
              "runAsNonRoot" = true
              "seccompProfile" = {
                "type" = "RuntimeDefault"
              }
            }
          }
        },
      ]
      "securityContext" = {
        "fsGroupChangePolicy" = "Always"
        "supplementalGroups" = []
        "sysctls" = []
      }
    }
  }
}
