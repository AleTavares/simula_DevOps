terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.20"
    }
  }
}

provider "docker" {}

resource "docker_network" "devops_net" {
  name = "devops_network"
}

resource "docker_volume" "pgdata" {
  name = "pgdata"
}

resource "docker_image" "postgres_image" {
  name = "postgres:13"
}

resource "docker_container" "postgres" {
  name  = "devops-postgres"
  image = docker_image.postgres_image.name

  env = [
    "POSTGRES_USER=${var.db_user}",
    "POSTGRES_PASSWORD=${var.db_password}",
    "POSTGRES_DB=${var.db_name}",
  ]

  networks_advanced {
    name = docker_network.devops_net.name
  }

  volumes {
    volume_name    = docker_volume.pgdata.name
    container_path = "/var/lib/postgresql/data"
  }
}

resource "docker_image" "app_image" {
  name = var.app_image
}

resource "docker_container" "app" {
  name  = "devops-app"
  image = docker_image.app_image.name

  networks_advanced {
    name = docker_network.devops_net.name
  }

  env = [
    "DB_HOST=${docker_container.postgres.name}",
    "DB_USER=${var.db_user}",
    "DB_PASSWORD=${var.db_password}",
    "DB_NAME=${var.db_name}",
  ]

  ports {
    internal = var.app_port
    external = var.app_port
  }

  depends_on = [docker_container.postgres]
}
