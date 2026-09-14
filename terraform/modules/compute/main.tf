# Jenkins Controller (Public Subnet)
resource "google_compute_instance" "jenkins" {
  name         = "jenkins-server"
  machine_type = "e2-medium"
  zone         = var.zone
  tags         = ["public-node", "jenkins"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
      size  = 20
    }
  }

  network_interface {
    subnetwork = var.public_subnet_id
    access_config {}
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${file(pathexpand(var.ssh_pub_key_path))}"
  }
}

# Prometheus Monitoring Server (Public Subnet)
resource "google_compute_instance" "prometheus" {
  name         = "prometheus-server"
  machine_type = "e2-medium"
  zone         = var.zone
  tags         = ["public-node", "monitoring"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
      size  = 20
    }
  }

  network_interface {
    subnetwork = var.public_subnet_id
    access_config {}
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${file(pathexpand(var.ssh_pub_key_path))}"
  }
}

# Private Application Nodes (Nginx & Frontend)
resource "google_compute_instance" "app_nodes" {
  count        = 2
  name         = "app-node-0${count.index + 1}"
  machine_type = "e2-medium"
  zone         = var.zone
  tags         = ["private-node", "app-node"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
      size  = 20
    }
  }

  network_interface {
    subnetwork = var.private_subnet_id
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${file(pathexpand(var.ssh_pub_key_path))}"
  }
}

# Instance Group for Load Balancer
resource "google_compute_instance_group" "app_group" {
  name        = "app-instance-group"
  description = "Instance group for frontend application nodes"
  zone        = var.zone

  instances = [
    google_compute_instance.app_nodes[0].self_link,
    google_compute_instance.app_nodes[1].self_link,
  ]

  named_port {
    name = "http"
    port = 80
  }
}

# Firewall Rule to Allow Google Health Check and LB Probes
resource "google_compute_firewall" "allow_lb_health_checks" {
  name    = "allow-lb-and-health-checks"
  network = var.vpc_name

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]
  target_tags   = ["app-node"]
}