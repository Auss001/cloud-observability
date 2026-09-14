output "vpc_name" {
  description = "Name of the VPC network"
  value       = google_compute_network.vpc.name
}

output "public_subnet_id" {
  description = "Public subnetwork self_link or ID"
  value       = google_compute_subnetwork.public.id
}

output "private_subnet_id" {
  description = "Private subnetwork self_link or ID"
  value       = google_compute_subnetwork.private.id
}