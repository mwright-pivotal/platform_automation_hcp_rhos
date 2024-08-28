resource "kubernetes_manifest" "cephfilesystem_rook_ceph_myfs" {
  manifest = {
    "apiVersion" = "ceph.rook.io/v1"
    "kind" = "CephFilesystem"
    "metadata" = {
      "name" = "myfs"
      "namespace" = "rook-ceph"
    }
    "spec" = {
      "dataPools" = [
        {
          "failureDomain" = "host"
          "name" = "replicated"
          "parameters" = {
            "compression_mode" = "none"
          }
          "replicated" = {
            "requireSafeReplicaSize" = true
            "size" = 3
          }
        },
      ]
      "metadataPool" = {
        "parameters" = {
          "compression_mode" = "none"
        }
        "replicated" = {
          "requireSafeReplicaSize" = true
          "size" = 3
        }
      }
      "metadataServer" = {
        "activeCount" = 1
        "activeStandby" = true
        "livenessProbe" = {
          "disabled" = false
        }
        "placement" = {
          "podAntiAffinity" = {
            "preferredDuringSchedulingIgnoredDuringExecution" = [
              {
                "podAffinityTerm" = {
                  "labelSelector" = {
                    "matchExpressions" = [
                      {
                        "key" = "app"
                        "operator" = "In"
                        "values" = [
                          "rook-ceph-mds",
                        ]
                      },
                    ]
                  }
                  "topologyKey" = "topology.kubernetes.io/zone"
                }
                "weight" = 100
              },
            ]
            "requiredDuringSchedulingIgnoredDuringExecution" = [
              {
                "labelSelector" = {
                  "matchExpressions" = [
                    {
                      "key" = "app"
                      "operator" = "In"
                      "values" = [
                        "rook-ceph-mds",
                      ]
                    },
                  ]
                }
                "topologyKey" = "kubernetes.io/hostname"
              },
            ]
          }
        }
        "priorityClassName" = "system-cluster-critical"
        "startupProbe" = {
          "disabled" = false
        }
      }
      "preserveFilesystemOnDelete" = true
    }
  }
}

resource "kubernetes_manifest" "cephfilesystemsubvolumegroup_rook_ceph_myfs_csi" {
  manifest = {
    "apiVersion" = "ceph.rook.io/v1"
    "kind" = "CephFilesystemSubVolumeGroup"
    "metadata" = {
      "name" = "myfs-csi"
      "namespace" = "rook-ceph"
    }
    "spec" = {
      "filesystemName" = "myfs"
      "name" = "csi"
      "pinning" = {
        "distributed" = 1
      }
    }
  }
}
