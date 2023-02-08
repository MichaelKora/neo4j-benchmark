resource "google_compute_instance" "neo4j" {
  name         = "sutneo4j"
  machine_type = "e2-standard-16"
  zone         = "us-west1-b"
  /* zone         = "europe-west3-c"
  machine_type = "e2-standard-16" */

  boot_disk {
    initialize_params {
      size  = 40
      image = "ubuntu-2204-jammy-v20221101a"
    }
  }

  network_interface {
    network = "default"

    access_config {
      # Include this section to give the VM an external IP address
    }
  }
  metadata = {
    ssh-keys = "${var.user}:${file("./keys/gcp_tf.pub")}"
  }

  provisioner "file" {
    source      = "resources/"
    destination = "/tmp/"

    connection {
      type        = "ssh"
      user        = var.user
      password    = var.root_password
      host        = google_compute_instance.neo4j.network_interface.0.access_config.0.nat_ip
      private_key = file("./keys/gcp_tf")
    }
  }
  tags                    = ["sut-vm"]
  metadata_startup_script = <<SCRIPT
    export DEBIAN_FRONTEND=noninteractive
    sudo apt update
    sudo apt upgrade -y
    sudo apt install -y -q apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository --yes "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
    sudo apt update
    sudo apt upgrade -y
    sudo apt install -y -q docker-ce

    sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose

    cd /tmp
    touch ahahha.txt
    sudo docker-compose up -d

    sudo mkdir -p /tmp/csb/test
    sudo touch /tmp/csb/test/hello.txt
    sudo echo "Hello World!" >> /tmp/csb/test/hello.txt
    SCRIPT
}

resource "google_compute_firewall" "sut-vm" {
  name    = "sut-terraform-firewall"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["8080", "7474", "7687", "80", "22", "8083"]
  }

  //Allow trafic from everywhere to instance with the tag: "sut-vm"
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["sut-vm"]
}
