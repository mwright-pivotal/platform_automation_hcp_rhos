# E2E Platform GitOps with ILM and SLM on bare metal infra

This repository explores an alternative platform for managing, operating a VM and Container platform along with automation to manage the App workloads using a Windows VM example, and an AI/Computer Vision container based workload with dependence on GPU resources.

The method of delivery intends to highlight Infrastructure Lifecycle Management (ILM) and Security Lifecycle Management (SLM) right from the beginning.  Also we want to not just focus on modern custom applications as it assumes some enterprises have built up a methodologies for modern custom apps already, but legacy and COTs VM based workloads are often left behind.  

If we are to consider investing in alternative virtualization platforms for private datacenter, then we want to drive better business outcomes than what has been achieved with the incumbent platform.   Examples of business outcomes to improve upon are addressing Cyber Materiality, Reduction of monolithic vendor/Concentration Risk, Policy Driven Private Cloud Cost Containment.

## High level recipe

1. 3 on-prem, physical hosts with NVidia GPU (optional), 2 disk partitions
2. Basic flat network, with egress outbound only to public internet
3. Access to Redhat Hybrid Cloud Console and Hashicorp Cloud Platform
   a. console.redhat.com
   b. portal.cloud.hashicorp.com
4. Use Redhat Hybrid Cloud to define a new Openshift Cluster and generate bootstrap images for bare metal hosts
5. Onboard newly discovered hosts and assign to cluster with dual role, Controlplane and Worker roles
6. Deploy HCP Terraform Operator into newly formed Cluster from Redhat console
7. Configure HCP org and workspace to leverage new TF Agent Pool by default
8. COnfigure HCP Terraform workspace to trigger from VCS, referencing a fork of this repo.

