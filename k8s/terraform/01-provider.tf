terraform {
  backend "s3" {
    bucket = "nomer26-backend"
    key = "terraform/terraform.tfstate"
    region = "ap-northeast-2"
    encrypt = true
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.47.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.4.3"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0.4"
    }

    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "~> 2.2.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.16.1"
    }
  }

  required_version = "~> 1.3"
}


provider "kubernetes" {
    host = module.eks.cluster_endpoint
    cluster_ca_certificate = base64encode(module.eks.cluster_certificate_authority_data)
}
provider "helm" {
  kubernetes {
    host = module.eks.cluster_endpoint
    cluster_ca_certificate = base64encode(module.eks.cluster_certificate_authority_data)
  }
}


provider "aws" {
    region = var.region
}
