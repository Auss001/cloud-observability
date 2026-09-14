# VPC Network
resource "google_compute_network" "vpc" {
  name                    = var.network_name
  auto_create_subnetworks = false
}

# Public Subnet
resource "google_compute_subnetwork" "public_subnet" {
  name          = "${var.network_name}-public-subnet"
  ip_cidr_range = var.public_subnet_cidr
  region        = var.region
  network       = google_compute_network.vpc.id
}

# Private Subnet
resource "google_compute_subnetwork" "private_subnet" {
  name                     = "${var.network_name}-private-subnet"
  ip_cidr_range            = var.private_subnet_cidr
  region                   = var.region
  network                  = google_compute_network.vpc.id
  private_ip_google_access = true
}

# Cloud Router & NAT Gateway (for private subnet internet access)
resource "google_compute_router" "router" {
  name    = "${var.network_name}-router"
  region  = var.region
  network = google_compute_network.vpc.id
}

resource "google_compute_router_nat" "nat" {
  name                               = "${var.network_name}-nat"
  router                             = google_compute_router.router.name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

# Firewall: Inbound for Public Subnet (SSH, Jenkins, Prometheus)
resource "google_compute_firewall" "allow_public_inbound" {
  name    = "${var.network_name}-allow-public-inbound"
  network = google_compute_network.vpc.id

  allow {
    protocol = "tcp"
    ports    = ["22", "8080", "9090"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["public-node"]
}

# Firewall: Internal Subnet Communication (SSH & Node Exporter 9100)
resource "google_compute_firewall" "allow_internal_metrics" {
  name    = "${var.network_name}-allow-internal-metrics"
  network = google_compute_network.vpc.id

  allow {
    protocol = "tcp"
    ports    = ["22", "9100"]
  }

  source_ranges = [var.public_subnet_cidr]
  target_tags   = ["private-node"]
}