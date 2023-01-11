
# IAM for S.A       # https://github.com/terraform-aws-modules/terraform-aws-iam/blob/master/examples/iam-role-for-service-accounts-eks/main.tf
module "load_balancer_controller_irsa_role" {
  source    = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name                              = "load-balancer-controller"
  attach_load_balancer_controller_policy = true

  oidc_providers = {
    github-actions = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
    }
  }
}

resource "kubernetes_service_account" "alb-ic-sa" {
    metadata {
      name = var.alb-ic-name
      namespace = "kube-system"
      labels = {
        "app.kubernetes.io/name" = var.alb-ic-name
        "app.kubernetes.io/component" = "controller"
      }
      annotations = {
        "eks.amazonaws.com/role-arn" = module.load_balancer_controller_irsa_role.iam_role_arn
        "eks.amazonaws.com/sts-regional-endpoints" = "true"   # 이건 뭘까??
      }
    }
}

resource "helm_release" "alb-ic" {
    name = var.alb-ic-name
    repository = "https://aws.github.io/eks-charts"
    chart = "aws-load-balancer-controller"
    namespace = "kube-system"
    depends_on = [
      kubernetes_service_account.alb-ic-sa
    ]
    set {
        name = "region"
        value = var.region
    }
    set {
        name = "vpcId"
        value = module.vpc.vpc_id
    }
    set {
        name = "serviceAccount.create"  # 이미 생성함
        value = "false"
    }
    set {
        name = "serviceAccount.name" 
        value = var.alb-ic-name
        # value = kubernetes_service_account.alb-ic-sa.metadata[0].name  
        # 'cluster_ca_certificate' is not a valid PEM encodedcertificate  /  kubernetes manifest object를 사용하는 경우 Error
    }
    set {
        name = "clusterName"
        value = local.cluster_name
    }
}