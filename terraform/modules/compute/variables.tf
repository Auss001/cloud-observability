variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The GCP region"
  type        = string
}

variable "zone" {
  description = "The GCP zone"
  type        = string
}

variable "public_subnet_id" {
  description = "Subnet self link or ID for public instances"
  type        = string
}

variable "private_subnet_id" {
  description = "Subnet self link or ID for private instances"
  type        = string
}

variable "ssh_user" {
  description = "The SSH username"
  type        = string
  default     = "devops"
}

variable "ssh_pub_key_path" {
  description = "Path to public SSH key"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "vpc_name" {
  description = "Name of the VPC network"
  type        = string
}