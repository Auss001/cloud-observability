variable "network_name" {
  type    = string
  default = "observability-vpc"
}

variable "region" {
  type = string
}

variable "public_subnet_cidr" {
  type = string
}

variable "private_subnet_cidr" {
  type = string
}