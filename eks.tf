# - Checklist
# Network
    # VPC & Subnet
        # Service IPv4 range ; 172.20.0.0/16
# Compute Spec
# Security
    # 보안그룹
    # Policy 
        # AmazonEKSClusterPolicy
        # AmazonEKSVPCResourceController
        # AmazonEC2ContainerRegistryReadOnly
        # AmazonEKSWorkerNodePolicy
        # AmazonEKS_CNI_Policy
# HA
# Dependency 
    # Subnet TAG for Autodetection  O
    # Node TAG for managed (owned)  O

# Provisioning Time  
    # NAT Gateway : 1m 30s
    # EKS Cluster : 11m 10s
    # Worker Node Group : 2m 10s
    # Control plane Group : 20s 
    # Addpms : 1,

module "eks" {
  source = "terraform-aws-modules/eks/aws"
# version = ""
  
  cluster_name = local.cluster_name
  cluster_version = "1.24"   # 기준 :    Default 1.23   /  쿠버는 업데이트 속도가 매우 빨라 서드파티들이 따라오질 못함. 1.25의 경우 특정 Helm 배포 시 PSP 문제 발생.

  vpc_id = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.private_subnets

  cluster_endpoint_public_access  = true

  cluster_addons = {        # Map of cluster addon configurations to enable for the cluster. Addon name can be the map keys or set with name , https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_addon
  # Available add-ons
    # Amazon VPC CNI plugin for Kubernetes
    # CoreDNS
    # kube-proxy
    # ADOT
    # Amazon EBS CSI
    coredns = {
        most_recent = true
    }
    kube-proxy = {
        most_recent = true
    }
    vpc-cni = {
        most_recent = true
    }
  }

  # Worker node Group
  eks_managed_node_group_defaults = {
    min_size = 1
    max_size = 1
    desired_size = 1

    instance_types = ["t3.small"]
  }
  eks_managed_node_groups = {
    follow-1 = {}
    follow-2 = {}
  }


  # Control plane Group 
    # 동일한 인스턴스 유형 & AMI & IAM Role
    # 
#   self_managed_node_group_defaults = {
#     instance_type = "t3.small"
#     update_launch_template_default_version = true   # Whether to update Default Version each update. (Default)
#     iam_role_additional_policies = {  # Additional policies to be added to the IAM role
#         AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
#             # Register as a managed instance
#             # Send heartbeat information
#             # Send and receive messages for Run Command and Session Manager
#             # Retrieve State Manager association details
#             # Read parameters in Parameter Store
#         # AmazonEC2ContainerRegistryReadOnly = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
#     }
#   }
#   self_managed_node_groups = {
#     one = {
#         name = "Control"

#         min_size = 1
#         max_size = 1
#         desired_size = 1

#         instance_types = ["t3.small"]
#     }
#   }
  tags = {
    Environment = "test"
    gitAction = true
  }
}