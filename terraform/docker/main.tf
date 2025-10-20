terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.2"
    }
  }
  required_version = ">= 1.0"
}

provider "docker" {
  host = "npipe:////./pipe/docker_engine" # Windows
  # Para Linux/Mac, use: host = "unix:///var/run/docker.sock"
}

# Rede Docker para comunicação entre containers
resource "docker_network" "app_network" {
  name = "devops_network"
}

# Volume para persistência do banco de dados
resource "docker_volume" "postgres_data" {
  name = "postgres_data"
}

# Container PostgreSQL
resource "docker_container" "postgres" {
  name  = "postgres"
  image = docker_image.postgres.image_id

  networks_advanced {
    name = docker_network.app_network.name
  }

  volumes {
    volume_name    = docker_volume.postgres_data.name
    container_path = "/var/lib/postgresql/data"
  }

  env = [
    "POSTGRES_USER=${var.db_user}",
    "POSTGRES_PASSWORD=${var.db_password}",
    "POSTGRES_DB=${var.db_name}"
  ]

  ports {
    internal = 5432
    external = 5432
  }

  healthcheck {
    test     = ["CMD-SHELL", "pg_isready -U ${var.db_user}"]
    interval = "10s"
    timeout  = "5s"
    retries  = 5
  }
}

# Imagem do PostgreSQL
resource "docker_image" "postgres" {
  name = "postgres:13"
}

# Imagem da aplicação (deve ser construída localmente)
resource "docker_image" "app" {
  name = "devops-api:latest"
  build {
    context    = "${path.module}/../.."
    dockerfile = "Dockerfile"
  }
}

# Container da aplicação Node.js
resource "docker_container" "app" {
  name  = "devops-api"
  image = docker_image.app.image_id

  networks_advanced {
    name = docker_network.app_network.name
  }

  env = [
    "PORT=${var.app_port}",
    "DB_USER=${var.db_user}",
    "DB_HOST=postgres",
    "DB_NAME=${var.db_name}",
    "DB_PASSWORD=${var.db_password}",
    "DB_PORT=5432"
  ]

  ports {
    internal = 3000
    external = var.app_port
  }

  depends_on = [docker_container.postgres]

  # Aguardar o banco de dados ficar pronto
  command = ["sh", "-c", "sleep 10 && npm start"]
}
