module "vpc" {
  source              = "./modules/vpc"
  region              = var.region
  public_subnet_cidr  = "10.0.1.0/24"
  private_subnet_cidr = "10.0.2.0/24"
}

module "compute" {
  source            = "./modules/compute"
  project_id        = var.project_id
  region            = var.region
  zone              = var.zone
  public_subnet_id  = module.vpc.public_subnet_id
  private_subnet_id = module.vpc.private_subnet_id
  vpc_name          = module.vpc.vpc_name
  ssh_user          = var.ssh_user
  ssh_pub_key_path  = var.ssh_pub_key_path
}

module "database" {
  source     = "./modules/database"
  region     = var.region
  network_id = module.vpc.network_id
}

# ==========================================
# EXTERNAL APPLICATION LOAD BALANCER
# ==========================================

resource "google_compute_global_address" "lb_ip" {
  name = "frontend-lb-ip"
}

resource "google_compute_health_check" "http_health_check" {
  name                = "app-http-health-check"
  check_interval_sec  = 10
  timeout_sec         = 5
  healthy_threshold   = 2
  unhealthy_threshold = 3

  http_health_check {
    port         = 80
    request_path = "/"
  }
}

resource "google_compute_backend_service" "app_backend" {
  name                  = "app-backend-service"
  protocol              = "HTTP"
  port_name             = "http"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  timeout_sec           = 30
  health_checks         = [google_compute_health_check.http_health_check.id]

  backend {
    group = module.compute.instance_group
  }
}

resource "google_compute_url_map" "app_url_map" {
  name            = "app-url-map"
  default_service = google_compute_backend_service.app_backend.id
}

resource "google_compute_target_http_proxy" "app_http_proxy" {
  name    = "app-http-proxy"
  url_map = google_compute_url_map.app_url_map.id
}

resource "google_compute_global_forwarding_rule" "app_forwarding_rule" {
  name                  = "app-forwarding-rule"
  ip_protocol           = "TCP"
  port_range            = "80"
  target                = google_compute_target_http_proxy.app_http_proxy.id
  ip_address            = google_compute_global_address.lb_ip.id
  load_balancing_scheme = "EXTERNAL_MANAGED"
}