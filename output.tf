output "cluster_endpoint" {
    value = module.eks.cluster_endpoint
}

output "auth_config" {
  value = module.eks.aws_auth_configmap_yaml
}