resource "kubernetes_deployment" "vue-app" {
  metadata {
    name = "vue-app-deployment"
    labels = {
      App = "vue-app"
    }
  }

  spec {
    replicas = 2
    selector {
      match_labels = {
        App = "vue-app"
      }
    }
    template {
      metadata {
        labels = {
          App = "vue-app"
        }
      }
      spec {
        container {
          image = "europe-southwest1-docker.pkg.dev/at1xuior6obet2v08788vh0bhguprg/docker-repo/vue-app:1.0.0"
          name  = "vue-app"

          port {
            container_port = 3000
          }

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "vue-app-svc" {
  metadata {
    name = "vue-app-svc"
  }
  spec {
    selector = {
      App = kubernetes_deployment.vue-app.spec.0.template.0.metadata[0].labels.App
    }
    port {
      port        = 3000
      target_port = 3000
    }

    type = "LoadBalancer"
  }
}

output "lb_ip" {
  value = kubernetes_service.vue-app-svc.status.0.load_balancer.0.ingress.0.ip
}

