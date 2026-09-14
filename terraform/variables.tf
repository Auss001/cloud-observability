variable "project_id" {
  type        = string
  description = "Google Cloud project ID"
}

variable "region" {
  type        = string
  default     = "us-central1"
}

variable "zone" {
  type        = string
  default     = "us-central1-a"
}

variable "public_subnet_cidr" {
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  type        = string
  default     = "10.0.2.0/24"
}

variable "ssh_user" {
  type        = string
  default     = "devops"
}

variable "ssh_public_key_path" {
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}