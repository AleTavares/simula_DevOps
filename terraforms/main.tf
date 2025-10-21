terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {}

# ----------------------
# Rede Docker
# ----------------------
resource "docker_network" "devops_network" {
  name = "devops_network"
}

# ----------------------
# Volume para Postgres
# ----------------------
resource "docker_volume" "pgdata" {
  name = "pgdata"
}


resource "docker_image" "node_api" {
  name = "minha-api:latest"

  build {
    context    = "${path.module}/.."
    dockerfile = "${path.module}/../Dockerfile"
  }
}




# ----------------------
# Container PostgreSQL
# ----------------------
resource "docker_container" "postgres" {
  name  = "devops-postgres"
  image = "postgres:13"

  env = [
    "POSTGRES_USER=admin",
    "POSTGRES_PASSWORD=admin123",
    "POSTGRES_DB=devops_class"
  ]

  networks_advanced {
    name = docker_network.devops_network.name
  }

  volumes {
    container_path = "/var/lib/postgresql/data"
    volume_name    = docker_volume.pgdata.name
  }

  ports {
    internal = 5432
    external = 5433   # Porta alterada para evitar conflito
  }

  restart = "unless-stopped"
}

# ----------------------
# Container da API NodeJS
# ----------------------
resource "docker_container" "api" {
  name  = "devops-api"
  image = docker_image.node_api.name

  env = [
    "DB_HOST=devops-postgres",
    "DB_NAME=devops_class",
    "DB_USER=admin",
    "DB_PASSWORD=admin123",
    "DB_PORT=5432"
  ]

  networks_advanced {
    name = docker_network.devops_network.name
  }

  ports {
    internal = 3000
    external = 3000
  }

  depends_on = [
    docker_container.postgres
  ]

  restart = "unless-stopped"
}
