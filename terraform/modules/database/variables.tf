variable "region" {
  type = string
}

variable "network_id" {
  type        = string
  description = "VPC network ID to connect via private services peering"
}

variable "db_name" {
  type    = string
  default = "observability_db"
}

variable "db_user" {
  type    = string
  default = "appuser"
}

variable "db_password" {
  type      = string
  default   = "SuperSecretPassword123!"
  sensitive = true
}