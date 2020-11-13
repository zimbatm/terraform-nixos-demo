# Create a bucket to hold the disk images
resource "google_storage_bucket" "boot_image" {
  name          = "${local.name}-images"
  location      = "EU"
  force_destroy = true
}

# Create a base image to boot the machines from
module "boot_image" {
  source = "github.com/tweag/terraform-nixos//google_image_nixos_custom?ref=cf957121926e803b1f1e1de7e2c1fe91fe8ab75e"

  bucket_name  = google_storage_bucket.boot_image.name
  nixos_config = "${path.module}/boot_image.nix"
}
