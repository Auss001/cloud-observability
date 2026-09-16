# Cloud Infrastructure & Observability Platform

An enterprise-grade, highly available cloud deployment on Google Cloud Platform (GCP). This project orchestrates automated Infrastructure as Code (IaC) via Terraform, automated multi-node configuration management with Ansible, and a real-time monitoring and observability pipeline via Prometheus.

---

## 🌐 Live Demonstration Endpoints

| Component | Endpoint / Access | Status |
| :--- | :--- | :--- |
| **Frontend Application** | [http://34.59.11.26](http://34.59.11.26) | **Live / Healthy** |
| **Jenkins CI/CD** | `http://35.238.12.89:8080` | **Active** |
| **Prometheus Telemetry** | `http://34.60.151.118:9090` | **Scraping (3/3 UP)** |
| **Cloud SQL (PostgreSQL)** | `10.0.2.x` (Private Service Connection) | **Peered / Encrypted** |

---

## Architecture Overview

```text
                                [ Internet Traffic ]
                                         │
                    ┌────────────────────┴────────────────────┐
                    │                                         │
            ┌───────▼────────┐                       ┌────────▼────────┐
            │   Jenkins VM   │                       │   Prometheus    │
            │  35.238.12.89  │                       │  34.60.151.118  │
            │  (CI/CD & SSH) │                       │  (Port 9090)    │
            └───────┬────────┘                       └────────┬────────┘
                    │                                         │
                    │         VPC Internal Peering            │
                    └────────────────────┬────────────────────┘
                                         │ (Scrape Port 9100)
                    ┌────────────────────┴────────────────────┐
                    │                                         │
            ┌───────▼────────┐                       ┌────────▼────────┐
            │  app-node-01   │                       │  app-node-02    │
            │  34.59.11.26   │                       │   10.0.2.3      │
            │ (Nginx / App)  │                       │ (Private Node)  │
            └───────┬────────┘                       └────────┬────────┘
                    │                                         │
                    └────────────────────┬────────────────────┘
                                         │
                             ┌───────────▼───────────┐
                             │ Cloud SQL (PostgreSQL)│
                             │ (Private Subnet / PSA)│
                             └───────────────────────┘



                             VPC Network & Subnets: Custom VPC hosting public subnets (10.0.1.0/24) and private subnets (10.0.2.0/24) with fine-grained ingress firewall policies and Cloud NAT for secure outbound package retrieval.

CI/CD Automation: Dedicated Jenkins instance acting as deployment orchestrator and SSH execution node.

Zero-Touch Configuration: Fully automated Ansible playbooks targeting compute instances to install system dependencies, manage users, start systemd daemons, and configure Nginx.

Observability Pipeline: Prometheus scraping Node Exporter daemons across all nodes (10.0.2.2:9100, 10.0.2.3:9100, localhost:9090) with targets confirmed healthy.

Data Layer: Peered Google Cloud SQL PostgreSQL database utilizing Private Service Access and Google Cloud Storage buckets for asset management.

Technology Stack


Repository Structure
Plaintext
.
├── ansible/
│   ├── inventory/
│   │   └── hosts.ini          # Managed node groups (app, prometheus, jenkins)
│   ├── roles/
│   │   ├── app_node/          # Nginx and custom frontend deployment
│   │   ├── jenkins/           # Jenkins installation and configuration
│   │   └── prometheus/        # Prometheus and Node Exporter daemon setup
│   └── site.yml               # Master orchestration playbook
├── frontend/
│   ├── index.html             # Real-time infrastructure status dashboard
│   ├── style.css              # Custom styling
│   └── app.js                 # Dynamic metadata & health-check scripts
├── terraform/
│   ├── modules/
│   │   ├── compute/           # Compute Engine instances, metadata, keys
│   │   ├── database/          # Cloud SQL Postgres and Private Service Access
│   │   ├── storage/           # Cloud Storage assets bucket
│   │   └── vpc/               # Subnets, Cloud NAT, Cloud Router, Firewalls
│   ├── main.tf                # Module coordination
│   ├── variables.tf           # Variable declarations
│   └── outputs.tf             # Provisioned IP addresses and connection strings
└── README.md
Verification & Deployment Runbook
1. Infrastructure Provisioning
Bash
cd terraform
terraform init
terraform apply -auto-approve
2. Configuration via Ansible
Run the master site playbook from the Jenkins controller or deployment terminal:

Bash
ansible-playbook -i inventory/hosts.ini site.yml
Play Recap: 4/4 nodes OK, 0 unreachable, 0 failed.

3. Monitoring Verification
Navigate to Prometheus Targets (http://34.60.151.118:9090/targets) to verify that all Node Exporter endpoints report State: UP.


---
| Component | Endpoint / Access | Status |
| :--- | :--- | :--- |
| **Frontend Application** | [http://34.59.11.26](http://34.59.11.26) | **Live / Healthy** |
| **Grafana Visualizations** | `http://34.60.151.118:3000` | **Active (Node Exporter Full)** |
| **Jenkins CI/CD** | `http://35.238.12.89:8080` | **Active** |
| **Prometheus Telemetry** | `http://34.60.151.118:9090` | **Scraping (3/3 UP)** |
| **Cloud SQL (PostgreSQL)** | `10.0.2.x` (Private Service Connection) | **Peered / Encrypted** |