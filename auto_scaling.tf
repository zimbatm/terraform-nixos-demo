# Here is an instance template that can be used in an instance group
resource "google_compute_instance_template" "auto_scaling" {
  name_prefix  = "${local.name}-auto-scaling-"
  machine_type = "n1-standard-2"

  tags = [local.name]

  disk {
    source_image = module.boot_image.self_link
    auto_delete  = true
    boot         = true
    disk_type    = "pd-ssd"
    disk_size_gb = "100"
  }

  network_interface {
    network = local.network
    access_config {}
  }

  scheduling {
    automatic_restart   = false # handled by the instance group manager
    preemptible         = true
    on_host_maintenance = "TERMINATE"
  }

  lifecycle {
    create_before_destroy = true
  }

  metadata = {
    enable-oslogin = "TRUE"
  }

  service_account {
    scopes = [
      "compute-rw", # write for self-shutdown
      "storage-ro",
      "storage-rw", # write to the caches
      "logging-write",
    ]
  }
}

# Now start N instances of that template
resource "google_compute_instance_group_manager" "auto_scaling" {
  name               = "${local.name}-auto-scaling"
  base_instance_name = "${local.name}-auto-scaling"
  zone               = local.zone
  target_size        = 2

  version {
    instance_template = google_compute_instance_template.auto_scaling.self_link
  }

  lifecycle {
    # ignore target_size, it's meant to be elastic
    ignore_changes = [target_size]
  }
}
