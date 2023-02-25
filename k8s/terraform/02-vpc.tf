module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
#  version = ""
  name = "gitAction-eks-vpc"
  cidr = var.vpc_cidr # "10.0.0.0/16"                                기준 : default vpc 는 172.31.0.0/16 으로 직관적이지 못함
  azs = var.available_azs  # ["ap-northeast-2a", "ap-northeast-2c"]  선정 기준 : t2.micro 사용
  
# Subnet
  private_subnets = var.subnet_srv_private   # ["10.0.1.0/24", "10.0.2.0/24","10.0.3.0/24"]  
 # private_lb_subnets = var.subnet_lb_private     # ["10.0.10.0/24"]

  public_subnets = var.subnet_srv_public     # ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
 # public_lb_subnets = var.subnet_lb_private     # ["10.0.110.0/24"]

#  enable_dns_hostnames = true #(default)
  enable_nat_gateway = true  
  single_nat_gateway = true
  one_nat_gateway_per_az = false
  
  # Tagging for ALB Ingress Controller AutoDetectioning 
  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                = 1
  }
  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = 1
  }
}