# Here is an example on how to incrementally re-deploy a single host

# Reserve a fixed IP, for convenience
resource "google_compute_address" "single_host" {
  name = "${local.name}-single-host"
}

resource "google_compute_disk" "single_host" {
  name = "${local.name}-single-host-data"
  type = "pd-ssd"
  zone = local.zone
  size = "30"
}

resource "google_compute_instance" "single_host" {
  name         = "${local.name}-single-host"
  machine_type = "n1-standard-2"
  zone         = local.zone
  tags         = [local.name]

  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = module.boot_image.self_link
      size  = "10"
    }
  }

  attached_disk {
    source      = google_compute_disk.single_host.self_link
    device_name = "single_host_data"
  }

  network_interface {
    network = local.network
    access_config {
      nat_ip = google_compute_address.single_host.address
    }
  }

  scheduling {
    on_host_maintenance = "MIGRATE"
    automatic_restart   = true
  }

  metadata = {
    enable-oslogin = true
  }

  service_account {
    scopes = [
      "compute-ro",
      "storage-ro",
      "logging-write",
    ]
  }

  lifecycle {
    ignore_changes = [
      # Don't automatically re-create the VM whenever the system image
      # changes. This is handled by the ./deploy.sh script.
      boot_disk
    ]
  }
}

module "deploy_single_host" {
  source = "github.com/tweag/terraform-nixos//deploy_nixos?ref=cf957121926e803b1f1e1de7e2c1fe91fe8ab75e"

  nixos_config = "${path.module}/single_host.nix"

  target_host = google_compute_instance.single_host.network_interface.0.access_config.0.nat_ip
  target_user = "root"
}

output "single_host_url" {
  value = "http://${google_compute_instance.single_host.network_interface.0.access_config.0.nat_ip}"
}

output "single_host_name" {
  value = google_compute_instance.single_host.name
}
