variable "project_id" {
  type        = string
  description = "GCP Project ID"
}

variable "region" {
  type        = string
  description = "Region for storage bucket"
}

variable "bucket_name_prefix" {
  type        = string
  default     = "observability-assets"
  description = "Prefix for the bucket name"
}