# E2E Platform GitOps with ILM and SLM on bare metal infra

This repository explores an alternative platform for managing, operating a VM and Container platform along with automation to manage the App workloads using a Windows VM example, and an AI/Computer Vision container based workload with dependence on GPU resources.

The method of delivery intends to highlight Infrastructure Lifecycle Management (ILM) and Security Lifecycle Management (SLM) right from the beginning.  Also we want to not just focus on modern custom applications as it assumes some enterprises have built up methodologies for modern custom apps already, but legacy and COTs VM based workloads are often left behind.  

If we are to consider investing in alternative virtualization platforms for private datacenter, then we want to drive better business outcomes than what has been achieved with the incumbent platform.   Examples of business outcomes to improve upon are addressing Cyber Materiality, Reduction of monolithic vendor/Concentration Risk, Policy Driven Private Cloud Cost Containment.

This process leverages desired state, GitOps to apply infrastructure as code for Day 0 - Day 2 platform operations as well as basics of DevSecOps for managing application deployments.

## High level recipe

1. 3 on-prem, physical hosts with NVidia GPU (optional), 2 disk partitions
2. Basic flat network, with egress outbound only to public internet
3. Access to Redhat Hybrid Cloud Console and Hashicorp Cloud Platform\
   a. console.redhat.com\
   b. portal.cloud.hashicorp.com
4. Use Redhat Hybrid Cloud to define a new, vanilla Openshift Cluster and generate bootstrap images for bare metal hosts
5. Onboard newly discovered hosts and assign to cluster with dual role, Controlplane and Worker roles
6. Deploy HCP Terraform Operator into newly formed Cluster from Redhat console
7. Configure HCP org and workspace to leverage new TF Agent Pool by default
8. Configure HCP Terraform workspace to trigger from VCS, referencing a fork of this repo.\
   a. deploys clustered filesystem using Rook Ceph\
   b. adds NVidia GPU Operator and drivers
10. Use Packer and HCP Packer registry to manage VM image build pipelines and Vulerability Patch Management
11. Use HCP Vault Radar to ensure no secrets are leaked
12. Use HCP Vault to manage platform secrets
13. Use HCP Vault to manage credentials in a Windows VM

Screenshots
<img width="1252" alt="image" src="https://github.com/user-attachments/assets/96a02fdb-3d09-41fb-bc1b-8b879f39c2dc"><br/>
<img width="1636" alt="image" src="https://github.com/user-attachments/assets/14303d2e-1606-48ab-b6d9-a3da738e0f82"><br/>
<img width="1717" alt="image" src="https://github.com/user-attachments/assets/e250b494-f5e1-4c27-a701-e053549f5ec0"><br/>
<img width="1408" alt="image" src="https://github.com/user-attachments/assets/553eb674-33ab-4d51-ba50-bdca7c5753dd"><br/>


