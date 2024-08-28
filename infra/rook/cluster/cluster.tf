resource "kubernetes_manifest" "cephcluster_rook_ceph_rook_ceph" {
  manifest = {
    "apiVersion" = "ceph.rook.io/v1"
    "kind" = "CephCluster"
    "metadata" = {
      "name" = "rook-ceph"
      "namespace" = "rook-ceph"
    }
    "spec" = {
      "annotations" = null
      "cephVersion" = {
        "allowUnsupported" = false
        "image" = "quay.io/ceph/ceph:v18.2.4"
      }
      "cleanupPolicy" = {
        "allowUninstallWithVolumes" = false
        "confirmation" = ""
        "sanitizeDisks" = {
          "dataSource" = "zero"
          "iteration" = 1
          "method" = "quick"
        }
      }
      "continueUpgradeAfterChecksEvenIfNotHealthy" = false
      "crashCollector" = {
        "disable" = false
      }
      "csi" = {
        "cephfs" = null
        "readAffinity" = {
          "enabled" = false
        }
      }
      "dashboard" = {
        "enabled" = true
        "ssl" = true
      }
      "dataDirHostPath" = "/var/lib/rook"
      "disruptionManagement" = {
        "managePodBudgets" = true
        "osdMaintenanceTimeout" = 30
        "pgHealthCheckTimeout" = 0
      }
      "healthCheck" = {
        "daemonHealth" = {
          "mon" = {
            "disabled" = false
            "interval" = "45s"
          }
          "osd" = {
            "disabled" = false
            "interval" = "60s"
          }
          "status" = {
            "disabled" = false
            "interval" = "60s"
          }
        }
        "livenessProbe" = {
          "mgr" = {
            "disabled" = false
          }
          "mon" = {
            "disabled" = false
          }
          "osd" = {
            "disabled" = false
          }
        }
        "startupProbe" = {
          "mgr" = {
            "disabled" = false
          }
          "mon" = {
            "disabled" = false
          }
          "osd" = {
            "disabled" = false
          }
        }
      }
      "labels" = null
      "logCollector" = {
        "enabled" = true
        "maxLogSize" = "500M"
        "periodicity" = "daily"
      }
      "mgr" = {
        "allowMultiplePerNode" = false
        "count" = 2
        "modules" = [
          {
            "enabled" = true
            "name" = "rook"
          },
        ]
      }
      "mon" = {
        "allowMultiplePerNode" = false
        "count" = 3
      }
      "monitoring" = {
        "enabled" = false
        "metricsDisabled" = false
      }
      "network" = {
        "connections" = {
          "compression" = {
            "enabled" = false
          }
          "encryption" = {
            "enabled" = false
          }
          "requireMsgr2" = false
        }
      }
      "priorityClassNames" = {
        "mgr" = "system-cluster-critical"
        "mon" = "system-node-critical"
        "osd" = "system-node-critical"
      }
      "removeOSDsIfOutAndSafeToRemove" = false
      "resources" = null
      "skipUpgradeChecks" = false
      "storage" = {
        "config" = null
        "nodes" = [
          {
            "deviceFilter" = "sdb"
            "name" = "host1"
          },
          {
            "deviceFilter" = "sdb"
            "name" = "host2"
          },
          {
            "deviceFilter" = "sda"
            "name" = "host3"
          },
        ]
        "onlyApplyOSDPlacement" = false
        "useAllDevices" = true
        "useAllNodes" = true
      }
      "upgradeOSDRequiresHealthyPGs" = false
      "waitTimeoutForHealthyOSDInMinutes" = 10
    }
  }
}
