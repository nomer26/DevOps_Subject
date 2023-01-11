resource "kubernetes_deployment" "nginx" {
  metadata {
    name = "nginx"
    labels = {
        app = "nginx"
    }
  }
  spec {
    replicas = 2

    selector {
        match_labels = {
            app = "nginx"
        }
    }
    template {
      metadata {
        labels = {
            app = "nginx"
        }
      }
      spec {
        container {
            image = "nginx:latest"
            name = "nginx"
            port {
                container_port = 80
            }
        }
      }
    }
  }
}
resource "kubernetes_service" "nginx_svc" {
    metadata {
      name = "nginx-svc"
    }
    spec {
      selector = {
        app = kubernetes_deployment.nginx.metadata[0].labels.app
      }
      port {
        port = 80
        target_port = 80
      }
      type = "NodePort"
    }
  
}
resource "kubernetes_ingress" "nginx_ingress" {
    metadata {
        annotations = {
            "kubernetes.io/ingress.class" : "alb",
            "alb.ingress.kubernetes.io/scheme" : "internet-facing"
        }
        name = "nginx-ingress"
    }
    spec {
        backend {
          service_name = "nginx-svc"
          service_port = 80
        }
        rule {
          http {
            path {
                backend {
                    service_name = "nginx-svc"
                    service_port = 80
                }
                path = "/*"
            }
          }
        }
    }
}

# Pod -> SVC -> Ingress  리소스가 차례로 생성되고  ALB Ingress Controller 가 ALB를 생성 및 구성