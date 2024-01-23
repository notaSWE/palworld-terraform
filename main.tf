provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

resource "google_compute_firewall" "palworld_udp" {
  name    = "palworld-udp-8211"
  network = "default"

  allow {
    protocol = "udp"
    ports    = ["8211"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_instance" "default" {
  name         = "palworld-tf-vm"
  machine_type = "e2-standard-4" # 4x vCPU and 16GB RAM

  network_interface {
    network = "default"
    access_config {
      // Ephemeral IP
    }
  }

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10-buster-v20240110"
      size  = 100
    }
  }

  metadata_startup_script = file("${path.module}/startup.sh")

  scheduling {
    preemptible       = false
    on_host_maintenance = "MIGRATE"
    automatic_restart   = true
  }
}

