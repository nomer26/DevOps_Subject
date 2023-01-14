# - Checklist
# Network
    # VPC & Subnet
        # VPC CIDR           ; 10.0.0.0/16
        # Priv-Subnet        ; 10.0.1~3.0/24
        # Service IPv4 range ; 172.20.0.0/16
# Compute Spec
# Security
    # 보안그룹
        # No Bastion    O
        # EKS Default   O
    # Policy 
        # AmazonEKSClusterPolicy            O
        # AmazonEKSVPCResourceController    O
        # AmazonEC2ContainerRegistryReadOnly△
        # AmazonEKSWorkerNodePolicy         O
        # AmazonEKS_CNI_Policy              O
        # AWSLoadBalancerIAMPolicy (Custom) X -> Ansible
# HA
    # Control node ( 3-master )              O
    # Worker node  (Node group AutoScaling)      O
# Dependency 
    # Subnet TAG for Autodetection  O
    # Node TAG for managed (owned)  O
# Provisioning Time  
    # NAT Gateway : 1m 30s
    # EKS Cluster : 11m 10s
    # Worker Node Group : 2m 10s
    # Control plane Group : 20s 
    # Addons : 1m



locals {
    cluster_name = "github-actions"
}