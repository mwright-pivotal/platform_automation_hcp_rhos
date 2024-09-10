resource "kubernetes_manifest" "namespace_openshift_nfd" {
  manifest = {
    "apiVersion" = "v1"
    "kind" = "Namespace"
    "metadata" = {
      "labels" = {
        "name" = "openshift-nfd"
        "openshift.io/cluster-monitoring" = "true"
      }
      "name" = "openshift-nfd"
    }
  }
}

resource "kubernetes_manifest" "operatorgroup_openshift_nfd_openshift_nfd" {
  depends_on = [kubernetes_manifest.namespace_openshift_nfd]
  manifest = {
    "apiVersion" = "operators.coreos.com/v1"
    "kind" = "OperatorGroup"
    "metadata" = {
      "generateName" = "openshift-nfd-"
      "name" = "openshift-nfd"
      "namespace" = "openshift-nfd"
    }
    "spec" = {
      "targetNamespaces" = [
        "openshift-nfd",
      ]
    }
  }
}

resource "kubernetes_manifest" "subscription_openshift_nfd_nfd" {
  depends_on = [kubernetes_manifest.namespace_openshift_nfd]
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

resource "kubernetes_manifest" "nodefeaturediscovery_openshift_nfd_nfd_instance" {
  depends_on = [kubernetes_manifest.operatorgroup_openshift_nfd_openshift_nfd]
  manifest = {
    "apiVersion" = "nfd.openshift.io/v1"
    "kind" = "NodeFeatureDiscovery"
    "metadata" = {
      "name" = "nfd-instance"
      "namespace" = "openshift-nfd"
    }
    "spec" = {
      "customConfig" = {
        "configData" = <<-EOT
        - name: "more.kernel.features"
          matchOn:
          - loadedKMod: ["example_kmod3"]
        
        EOT
      }
      "instance" = ""
      "operand" = {
        "image" = "registry.redhat.io/openshift4/ose-node-feature-discovery-rhel9:v4.16.0"
        "imagePullPolicy" = "Always"
      }
      "topologyupdater" = false
      "workerConfig" = {
        "configData" = <<-EOT
        core:
        #  labelWhiteList:
        #  noPublish: false
          sleepInterval: 60s
        #  sources: [all]
        #  klog:
        #    addDirHeader: false
        #    alsologtostderr: false
        #    logBacktraceAt:
        #    logtostderr: true
        #    skipHeaders: false
        #    stderrthreshold: 2
        #    v: 0
        #    vmodule:
        ##   NOTE: the following options are not dynamically run-time configurable
        ##         and require a nfd-worker restart to take effect after being changed
        #    logDir:
        #    logFile:
        #    logFileMaxSize: 1800
        #    skipLogHeaders: false
        sources:
          cpu:
            cpuid:
        #     NOTE: whitelist has priority over blacklist
              attributeBlacklist:
                - "BMI1"
                - "BMI2"
                - "CLMUL"
                - "CMOV"
                - "CX16"
                - "ERMS"
                - "F16C"
                - "HTT"
                - "LZCNT"
                - "MMX"
                - "MMXEXT"
                - "NX"
                - "POPCNT"
                - "RDRAND"
                - "RDSEED"
                - "RDTSCP"
                - "SGX"
                - "SSE"
                - "SSE2"
                - "SSE3"
                - "SSE4.1"
                - "SSE4.2"
                - "SSSE3"
              attributeWhitelist:
          kernel:
            kconfigFile: "/path/to/kconfig"
            configOpts:
              - "NO_HZ"
              - "X86"
              - "DMI"
          pci:
            deviceClassWhitelist:
              - "0200"
              - "03"
              - "12"
            deviceLabelFields:
              - "class"
        
        EOT
      }
    }
  }
}
