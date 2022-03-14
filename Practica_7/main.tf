terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.5.0"
    }
  }
}

provider "google" {
  credentials = file("./creds/creds-gcp.json")

  project = "tokyo-eye-341903"
  region  = "us-east1"
  zone    = "us-east1-c"
}

resource "google_compute_firewall" "firewall" {
    name    = "f-externalssh"
    network = "default"
    allow {
    protocol = "tcp"
    ports    = ["8080", "80", "22"]
    }
    source_ranges = ["0.0.0.0/0"]
    target_tags   = ["externalssh"]
}
resource "google_compute_firewall" "webserverrule" {
    name    = "g-webserver"
    network = "default"
    allow {
    protocol = "tcp"
    ports    = ["80","8080", "22"]
    }
    source_ranges = ["0.0.0.0/0"]
    target_tags   = ["webserver"]
}

resource "google_compute_address" "stat1" {
    name = "dir1"
    depends_on = [ google_compute_firewall.firewall ]
}

resource "google_compute_address" "stat2" {
    name = "dir2"
    depends_on = [ google_compute_firewall.firewall ]
}

resource "google_compute_instance" "desarrollo" {
    name          = "dev"
    machine_type  = "e2-medium"
    
    boot_disk {
        initialize_params {
            image = "ubuntu-1804-bionic-v20220213"
        }
    }
    network_interface {
        network = "default"

        access_config {
            nat_ip = google_compute_address.stat1.address
        }
    }

    metadata = {
        ssh-keys = "ubuntu:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCW6fRldaI6DqV1gHwJwzkjyv2YgFkgMb+TWzzkslptegJ7cqu2RfDpWM7jOU8ZufeYzAk9cQmBcUVfLRh6SJ/2zcYZCbQlRTqwrEhOSxvvDRHsRnjbM2rLFy3jI6WpcaqDMs2XWx1VAXqyqbdr027cFF3lHZ/4SoW+TSXf9myigrw/ieoIdI6en9fCz3qhtzLgaqx5sGf7HOf3dePwOOJlmgSqGPlPqbGlBO/7Cwt/VI3zNWVIpigtchKQbksOXTED0Bhh7ah11L1rsocJj3XNzg9JVJUp26i7DHJAePuh4nqeKCw/Fw7Z7deAux2ckZeyYA35QSDAwgPf2Ye8RKERzEvuL7hTnMb+4Qod07nVOISb8Pa33U3YSixjMPV2b40kFcEOJdA7CXKKdJJz8MlZWcBdI4ok+Q7gYl+7Lh7wrq9ETJ6+Y4ZdYBXFhQX+6kSUCSnSD8UVohKkb7hgOGxVnVfxTUpabE5rcykCxSyYc1J8Om0MfSnI5poi//QJ0y79W7+nGKY+jkWnd/U0EF7lUP+PODCIUTgE//v//kVruRY1kBHN0PB7AWw2Qh3DXN6ufqg2LOxIcxzdsfsnVXKazSMlfnh/DpGOO+OAiPklgAWiyZEONLWYeQZ9vJNpS9oMz2gKT1xu46CaY+p2Eidme/8o1sNUZn8sKebISuHXdQ== sicmariana8@gmail.com"
    }

    provisioner "remote-exec" {
        inline = [
            "sudo apt-get update -y",
            "sudo apt-get install apt-transport-https ca-certificates curl gnupg lsb-release -y",
            "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg",
            "echo \"deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null ",
            "sudo apt-get update -y",
            "sudo apt-get install docker-ce docker-ce-cli containerd.io -y",
            "sudo docker run hello-world",
            "sudo docker run -itd -p 8081:80 sicmmar/app-practica6:latest",
            "sudo docker ps -a",
        ]

        connection {
            type = "ssh"
            user = "ubuntu"
            host = google_compute_address.stat1.address
            private_key = file("./creds/private_rsa")
        }
    }
    
    tags = ["externalssh","webserver"]
}

resource "google_compute_instance" "produccion" {
    name          = "prod"
    machine_type  = "e2-medium"
    
    boot_disk {
        initialize_params {
            image = "ubuntu-1804-bionic-v20220213"
        }
    }
    network_interface {
        network = "default"

        access_config {
            nat_ip = google_compute_address.stat2.address
        }
    }

    metadata = {
        ssh-keys = "ubuntu:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCW6fRldaI6DqV1gHwJwzkjyv2YgFkgMb+TWzzkslptegJ7cqu2RfDpWM7jOU8ZufeYzAk9cQmBcUVfLRh6SJ/2zcYZCbQlRTqwrEhOSxvvDRHsRnjbM2rLFy3jI6WpcaqDMs2XWx1VAXqyqbdr027cFF3lHZ/4SoW+TSXf9myigrw/ieoIdI6en9fCz3qhtzLgaqx5sGf7HOf3dePwOOJlmgSqGPlPqbGlBO/7Cwt/VI3zNWVIpigtchKQbksOXTED0Bhh7ah11L1rsocJj3XNzg9JVJUp26i7DHJAePuh4nqeKCw/Fw7Z7deAux2ckZeyYA35QSDAwgPf2Ye8RKERzEvuL7hTnMb+4Qod07nVOISb8Pa33U3YSixjMPV2b40kFcEOJdA7CXKKdJJz8MlZWcBdI4ok+Q7gYl+7Lh7wrq9ETJ6+Y4ZdYBXFhQX+6kSUCSnSD8UVohKkb7hgOGxVnVfxTUpabE5rcykCxSyYc1J8Om0MfSnI5poi//QJ0y79W7+nGKY+jkWnd/U0EF7lUP+PODCIUTgE//v//kVruRY1kBHN0PB7AWw2Qh3DXN6ufqg2LOxIcxzdsfsnVXKazSMlfnh/DpGOO+OAiPklgAWiyZEONLWYeQZ9vJNpS9oMz2gKT1xu46CaY+p2Eidme/8o1sNUZn8sKebISuHXdQ== sicmariana8@gmail.com"
    }

    provisioner "remote-exec" {
        inline = [
            "sudo apt-get update -y",
            "sudo apt-get install apt-transport-https ca-certificates curl gnupg lsb-release -y",
            "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg",
            "echo \"deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null ",
            "sudo apt-get update -y",
            "sudo apt-get install docker-ce docker-ce-cli containerd.io -y",
            "sudo docker run hello-world",
            "sudo docker run -itd -p 8082:80 sicmmar/app-practica6:latest",
            "sudo docker ps -a",
        ]

        connection {
            type = "ssh"
            user = "ubuntu"
            host = google_compute_address.stat2.address
            private_key = file("./creds/private_rsa")
        }
    }
    
    tags = ["externalssh","webserver"]
}