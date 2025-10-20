terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {}

# Rede para comunicação entre containers
resource "docker_network" "app_network" {
  name = "app-network"
}

# Volume para persistência do PostgreSQL
resource "docker_volume" "db_data" {
  name = "postgres-data"
}

# Container do PostgreSQL
resource "docker_container" "postgres" {
  name  = "postgres-db"
  image = "postgres:13"
  restart = "unless-stopped"

  env = [
    "POSTGRES_USER=${var.db_user}",
    "POSTGRES_PASSWORD=${var.db_password}",
    "POSTGRES_DB=${var.db_name}"
  ]

  networks_advanced {
    name = docker_network.app_network.name
  }

  volumes {
    volume_name    = docker_volume.db_data.name
    container_path = "/var/lib/postgresql/data"
  }

  ports {
    internal = 5432
    external = 5432
  }
}

# Container da API Node.js
resource "docker_container" "api" {
  name  = "node-api"
  image = "minha-api-nodejs:latest" # Você precisa buildar esta imagem primeiro
  restart = "unless-stopped"

  env = [
    "DB_HOST=postgres-db",
    "DB_USER=${var.db_user}",
    "DB_PASSWORD=${var.db_password}",
    "DB_NAME=${var.db_name}",
    "DB_PORT=5432"
  ]

  networks_advanced {
    name = docker_network.app_network.name
  }

  ports {
    internal = 3000
    external = 3000
  }

  depends_on = [docker_container.postgres]
}