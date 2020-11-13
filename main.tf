provider "google" {
  project = "numtide-infra"
  region = "europe-west1"
}

locals {
  name = "terraform-nixos-demo"
  region = "europe-west1"
  zone = "europe-west1-b"
  network = "default"
}

data "google_compute_network" "default" {
  name = local.network
}

resource "google_compute_firewall" "main" {
  name    = local.name
  network = data.google_compute_network.default.self_link

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22", "80"]
  }

  source_tags = [local.name]
}
