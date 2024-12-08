resource "kubernetes_manifest" "securitycontextconstraints_rook_ceph" {
  manifest = {
    "allowHostDirVolumePlugin" = true
    "allowHostIPC" = true
    "allowHostNetwork" = false
    "allowHostPID" = false
    "allowHostPorts" = false
    "allowPrivilegedContainer" = true
    "allowedCapabilities" = [
      "MKNOD",
    ]
    "apiVersion" = "security.openshift.io/v1"
    "defaultAddCapabilities" = []
    "fsGroup" = {
      "type" = "MustRunAs"
    }
    "kind" = "SecurityContextConstraints"
    "metadata" = {
      "name" = "rook-ceph"
    }
    "priority" = null
    "readOnlyRootFilesystem" = false
    "requiredDropCapabilities" = [
      "All",
    ]
    "runAsUser" = {
      "type" = "RunAsAny"
    }
    "seLinuxContext" = {
      "type" = "MustRunAs"
    }
    "supplementalGroups" = {
      "type" = "RunAsAny"
    }
    "users" = [
      "system:serviceaccount:rook-ceph:rook-ceph-system",
      "system:serviceaccount:rook-ceph:rook-ceph-default",
      "system:serviceaccount:rook-ceph:rook-ceph-mgr",
      "system:serviceaccount:rook-ceph:rook-ceph-osd",
      "system:serviceaccount:rook-ceph:rook-ceph-rgw",
    ]
    "volumes" = [
      "configMap",
      "downwardAPI",
      "emptyDir",
      "hostPath",
      "persistentVolumeClaim",
      "projected",
      "secret",
    ]
  }
}

resource "kubernetes_manifest" "securitycontextconstraints_rook_ceph_csi" {
  manifest = {
    "allowHostDirVolumePlugin" = true
    "allowHostIPC" = true
    "allowHostNetwork" = true
    "allowHostPID" = true
    "allowHostPorts" = true
    "allowPrivilegedContainer" = true
    "allowedCapabilities" = [
      "SYS_ADMIN",
    ]
    "apiVersion" = "security.openshift.io/v1"
    "fsGroup" = {
      "type" = "RunAsAny"
    }
    "kind" = "SecurityContextConstraints"
    "metadata" = {
      "name" = "rook-ceph-csi"
    }
    "priority" = null
    "readOnlyRootFilesystem" = false
    "runAsUser" = {
      "type" = "RunAsAny"
    }
    "seLinuxContext" = {
      "type" = "RunAsAny"
    }
    "supplementalGroups" = {
      "type" = "RunAsAny"
    }
    "users" = [
      "system:serviceaccount:rook-ceph:rook-csi-rbd-plugin-sa",
      "system:serviceaccount:rook-ceph:rook-csi-rbd-provisioner-sa",
      "system:serviceaccount:rook-ceph:rook-csi-cephfs-plugin-sa",
      "system:serviceaccount:rook-ceph:rook-csi-cephfs-provisioner-sa",
      "system:serviceaccount:rook-ceph:rook-csi-nfs-plugin-sa",
      "system:serviceaccount:rook-ceph:rook-csi-nfs-provisioner-sa",
    ]
    "volumes" = [
      "configMap",
      "projected",
      "emptyDir",
      "hostPath",
    ]
  }
}

resource "kubernetes_manifest" "configmap_rook_ceph_rook_ceph_operator_config" {
  manifest = {
    "apiVersion" = "v1"
    "data" = {
      "CSI_CEPHFS_ATTACH_REQUIRED" = "true"
      "CSI_CEPHFS_FSGROUPPOLICY" = "File"
      "CSI_DISABLE_HOLDER_PODS" = "true"
      "CSI_ENABLE_CEPHFS_SNAPSHOTTER" = "true"
      "CSI_ENABLE_CSIADDONS" = "false"
      "CSI_ENABLE_ENCRYPTION" = "false"
      "CSI_ENABLE_LIVENESS" = "false"
      "CSI_ENABLE_NFS_SNAPSHOTTER" = "true"
      "CSI_ENABLE_RBD_SNAPSHOTTER" = "true"
      "CSI_ENABLE_TOPOLOGY" = "false"
      "CSI_ENABLE_VOLUME_GROUP_SNAPSHOT" = "true"
      "CSI_FORCE_CEPHFS_KERNEL_CLIENT" = "true"
      "CSI_GRPC_TIMEOUT_SECONDS" = "150"
      "CSI_NFS_ATTACH_REQUIRED" = "true"
      "CSI_NFS_FSGROUPPOLICY" = "File"
      "CSI_PLUGIN_ENABLE_SELINUX_HOST_MOUNT" = "false"
      "CSI_PLUGIN_PRIORITY_CLASSNAME" = "system-node-critical"
      "CSI_PROVISIONER_PRIORITY_CLASSNAME" = "system-cluster-critical"
      "CSI_PROVISIONER_REPLICAS" = "2"
      "CSI_RBD_ATTACH_REQUIRED" = "true"
      "CSI_RBD_FSGROUPPOLICY" = "File"
      "ROOK_CEPH_ALLOW_LOOP_DEVICES" = "false"
      "ROOK_CEPH_COMMANDS_TIMEOUT_SECONDS" = "15"
      "ROOK_CSI_ALLOW_UNSUPPORTED_VERSION" = "false"
      "ROOK_CSI_DISABLE_DRIVER" = "false"
      "ROOK_CSI_ENABLE_CEPHFS" = "true"
      "ROOK_CSI_ENABLE_NFS" = "false"
      "ROOK_CSI_ENABLE_RBD" = "true"
      "ROOK_DISABLE_DEVICE_HOTPLUG" = "false"
      "ROOK_DISCOVER_DEVICES_INTERVAL" = "60m"
      "ROOK_ENABLE_DISCOVERY_DAEMON" = "false"
      "ROOK_LOG_LEVEL" = "INFO"
      "ROOK_OBC_WATCH_OPERATOR_NAMESPACE" = "true"
      "ROOK_WATCH_FOR_NODE_FAILURE" = "true"
    }
    "kind" = "ConfigMap"
    "metadata" = {
      "name" = "rook-ceph-operator-config"
      "namespace" = "rook-ceph"
    }
  }
}

resource "kubernetes_manifest" "deployment_rook_ceph_rook_ceph_operator" {
  manifest = {
    "apiVersion" = "apps/v1"
    "kind" = "Deployment"
    "metadata" = {
      "labels" = {
        "app.kubernetes.io/component" = "rook-ceph-operator"
        "app.kubernetes.io/instance" = "rook-ceph"
        "app.kubernetes.io/name" = "rook-ceph"
        "app.kubernetes.io/part-of" = "rook-ceph-operator"
        "operator" = "rook"
        "storage-backend" = "ceph"
      }
      "name" = "rook-ceph-operator"
      "namespace" = "rook-ceph"
    }
    "spec" = {
      "replicas" = 1
      "selector" = {
        "matchLabels" = {
          "app" = "rook-ceph-operator"
        }
      }
      "strategy" = {
        "type" = "Recreate"
      }
      "template" = {
        "metadata" = {
          "labels" = {
            "app" = "rook-ceph-operator"
          }
        }
        "spec" = {
          "containers" = [
            {
              "args" = [
                "ceph",
                "operator",
              ]
              "env" = [
                {
                  "name" = "ROOK_CURRENT_NAMESPACE_ONLY"
                  "value" = "false"
                },
                {
                  "name" = "ROOK_HOSTPATH_REQUIRES_PRIVILEGED"
                  "value" = "true"
                },
                {
                  "name" = "DISCOVER_DAEMON_UDEV_BLACKLIST"
                  "value" = "(?i)dm-[0-9]+,(?i)rbd[0-9]+,(?i)nbd[0-9]+"
                },
                {
                  "name" = "ROOK_ENABLE_MACHINE_DISRUPTION_BUDGET"
                  "value" = "false"
                },
                {
                  "name" = "ROOK_UNREACHABLE_NODE_TOLERATION_SECONDS"
                  "value" = "5"
                },
                {
                  "name" = "NODE_NAME"
                  "valueFrom" = {
                    "fieldRef" = {
                      "fieldPath" = "spec.nodeName"
                    }
                  }
                },
                {
                  "name" = "POD_NAME"
                  "valueFrom" = {
                    "fieldRef" = {
                      "fieldPath" = "metadata.name"
                    }
                  }
                },
                {
                  "name" = "POD_NAMESPACE"
                  "valueFrom" = {
                    "fieldRef" = {
                      "fieldPath" = "metadata.namespace"
                    }
                  }
                },
              ]
              "image" = "rook/ceph:master"
              "name" = "rook-ceph-operator"
              "securityContext" = {
                "runAsGroup" = 2016
                "runAsNonRoot" = true
                "runAsUser" = 2016
              }
              "volumeMounts" = [
                {
                  "mountPath" = "/var/lib/rook"
                  "name" = "rook-config"
                },
                {
                  "mountPath" = "/etc/ceph"
                  "name" = "default-config-dir"
                },
              ]
            },
          ]
          "serviceAccountName" = "rook-ceph-system"
          "tolerations" = [
            {
              "effect" = "NoExecute"
              "key" = "node.kubernetes.io/unreachable"
              "operator" = "Exists"
              "tolerationSeconds" = 5
            },
          ]
          "volumes" = [
            {
              "emptyDir" = {}
              "name" = "rook-config"
            },
            {
              "emptyDir" = {}
              "name" = "default-config-dir"
            },
          ]
        }
      }
    }
  }
}
