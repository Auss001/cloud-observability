resource "random_id" "bucket_suffix" {
  byte_length = 4
}

resource "google_storage_bucket" "app_bucket" {
  name                        = "${var.bucket_name_prefix}-${random_id.bucket_suffix.hex}"
  location                    = var.region
  project                     = var.project_id
  uniform_bucket_level_access = true
  force_destroy               = true

  versioning {
    enabled = true
  }
}