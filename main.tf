provider "google" {
  credentials = file(var.credentials_path) #jsondecode(base64decode(secrets.GCP_CREDENTIALS))
  project     = var.project_id
  region      = "us-central1"
}

resource "google_compute_instance" "web_instance" {
  name         = "web-instance"
  machine_type = "e2-medium"
  zone         = "us-central1-c"
  tags         = ["web", "test"]

  network_interface {
    network            = google_compute_network.mostafa_vpc.self_link
    subnetwork_project = google_compute_subnetwork.mostafa_subnet.project
    subnetwork         = google_compute_subnetwork.mostafa_subnet.name
  }

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }

  metadata_startup_script = "start.sh"
}

resource "google_storage_bucket" "test_bucket" {
  name          = "mostafa-test-bucket"
  location      = "US"
  storage_class = "MULTI_REGIONAL"
}

resource "google_sql_database_instance" "pg_instance" {
  name             = "mostafa-instance"
  database_version = "POSTGRES_15"
  region           = "us-central1"
  settings {
    tier = "db-f1-micro"
  }
  deletion_protection = false
  depends_on          = [google_storage_bucket.test_bucket]
}

resource "google_compute_network" "mostafa_vpc" {
  name                    = "mostafa-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "mostafa_subnet" {
  name          = "mostafa-subnet"
  network       = google_compute_network.mostafa_vpc.name
  region        = "us-central1"
  ip_cidr_range = "10.0.0.0/20"
}

resource "google_compute_router" "mostafa_router" {
  name    = "mostafa-router"
  network = google_compute_network.mostafa_vpc.name
  region  = "us-central1"
}

resource "google_compute_router_nat" "mostafa_nat" {
  name                               = "mostafa-nat"
  router                             = google_compute_router.mostafa_router.name
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

resource "google_compute_firewall" "allow_http" {
  name    = "allow-http"
  network = google_compute_network.mostafa_vpc.name
  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["web", "test"]
}

resource "google_compute_firewall" "https_firewall" {
  name    = "allow-https"
  network = google_compute_network.mostafa_vpc.name
  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["web", "test"]
}
