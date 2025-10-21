terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}

provider "docker" {}

# Rede Docker
resource "docker_network" "app_net" {
  name = "app_network"
}

# Imagem do PostgreSQL
resource "docker_image" "postgres" {
  name = "postgres:13"
  keep_locally = false
}

# Container do PostgreSQL
resource "docker_container" "postgres" {
  name  = "postgres_db"
  image = "postgres:13"

  env = [
    "POSTGRES_USER=admin",
    "POSTGRES_PASSWORD=admin123",
    "POSTGRES_DB=appdb"
  ]

  networks_advanced {
    name = docker_network.app_net.name
  }



  ports {
    internal = 5432
    external = 5432
  }
}

# Container da API Node.js
resource "docker_container" "api" {
  name  = "node_api"
  image = "node-api:latest"

  env = [
    "DB_HOST=${docker_container.postgres.name}",
    "DB_USER=admin",
    "DB_PASSWORD=admin123",
    "DB_NAME=appdb"
  ]

  networks_advanced {
    name = docker_network.app_net.name
  }

  ports {
    internal = 3000
    external = 3000
  }

  depends_on = [docker_container.postgres]
}