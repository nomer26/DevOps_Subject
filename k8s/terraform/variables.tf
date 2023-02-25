variable "region" {
  type = string
}

variable "vpc_cidr" {
  type = string
}   

variable "available_azs" {
  type = list(string)
}

variable "subnet_srv_private" {
  description = "private subnet for eks nodes"
  type = list(string)
}

variable "subnet_srv_public" {
  type = list(string)
}

variable "alb-ic-name" {
    description = "Key Name of ALB Ingress Controller"
    type = string
}

variable "cluster_name" {
  type = string
}
