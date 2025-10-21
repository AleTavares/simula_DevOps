terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.2"
    }
  }
}

provider "docker" {}

resource "docker_network" "app_network" {
  name = "app_network"
}

resource "docker_container" "postgres" {
  name  = var.postgres_container_name
  image = "postgres:13"
  env = [
    "POSTGRES_DB=${var.db_name}",
    "POSTGRES_USER=${var.db_user}",
    "POSTGRES_PASSWORD=${var.db_password}"
  ]
  ports {
    internal = 5432
    external = var.postgres_port
  }

  networks_advanced {
    name = docker_network.app_network.name
  }
  volumes {
    host_path      = "/postgres/data"
    container_path = "/var/lib/postgres/data"
  }
}

resource "docker_container" "node" {
  name  = var.node_container_name
  image = "node:22"

  volumes {
    host_path      = "--"
    container_path = "/usr/src/app"
  }

  working_dir = "/usr/src/app"

  command = ["npm", "install", "npm", "start"]

  ports {
    internal = 3000
    external = var.node_port
  }

  restart = "unless-stopped"

  depends_on = [docker_container.postgres]
  networks_advanced {
    name = docker_network.app_network.name
  }
}