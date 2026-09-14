output "jenkins_url" {
  description = "Public URL for Jenkins dashboard"
  value       = "http://${module.compute.jenkins_ip}:8080"
}

output "prometheus_url" {
  description = "Public URL for Prometheus monitoring dashboard"
  value       = "http://${module.compute.prometheus_ip}:9090"
}

output "app_internal_ips" {
  description = "Internal IP addresses of the application nodes"
  value       = module.compute.app_internal_ips
}

output "load_balancer_url" {
  description = "Public URL for the frontend application load balancer"
  value       = "http://${google_compute_global_address.lb_ip.address}"
}