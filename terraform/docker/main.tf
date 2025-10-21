terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

provider "docker" {}

# Criar rede para comunicação entre containers
resource "docker_network" "devops_network" {
  name = "devops-network"
}

# Volume para persistência do PostgreSQL
resource "docker_volume" "postgres_data" {
  name = "postgres-data"
}

# Container PostgreSQL
resource "docker_container" "postgres" {
  image = "postgres:13"
  name  = "devops-postgres"
  
  networks_advanced {
    name = docker_network.devops_network.name
  }

  volumes {
    volume_name    = docker_volume.postgres_data.name
    container_path = "/var/lib/postgresql/data"
  }

  volumes {
    host_path      = "${path.cwd}/../../init.sql"
    container_path = "/docker-entrypoint-initdb.d/init.sql"
    read_only      = true
  }

  env = [
    "POSTGRES_USER=devops",
    "POSTGRES_PASSWORD=admin",
    "POSTGRES_DB=devops_class"
  ]

  ports {
    internal = 5432
    external = 5432
  }
}

# Container da API NodeJS
resource "docker_container" "api" {
  image = "devops-api:latest"
  name  = "devops-api"
  
  networks_advanced {
    name = docker_network.devops_network.name
  }

  env = [
    "DB_HOST=devops-postgres",
    "DB_USER=devops",
    "DB_PASSWORD=admin",
    "DB_NAME=devops_class",
    "DB_PORT=5432"
  ]

  ports {
    internal = 3000
    external = 3000
  }

  depends_on = [docker_container.postgres]
}