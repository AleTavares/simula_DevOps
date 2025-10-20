terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
  required_version = ">= 1.0"
}

# Configuração do provider Docker
provider "docker" {}

# Rede para comunicação entre containers
resource "docker_network" "devops_network" {
  name = "devops-network"
}

# Volume para persistência dos dados do PostgreSQL
resource "docker_volume" "postgres_data" {
  name = "devops-postgres-data"
}

# Construir a imagem da aplicação NodeJS
resource "docker_image" "app_image" {
  name = "devops-api:latest"
  build {
    context = "../.."  # Caminho para a raiz do projeto onde está o Dockerfile
    dockerfile = "Dockerfile"
  }
}

# Container do PostgreSQL
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

  env = [
    "POSTGRES_USER=postgres",
    "POSTGRES_PASSWORD=admin",
    "POSTGRES_DB=devops_class"
  ]

  ports {
    internal = 5432
    external = 5432
  }

  # Health check
  healthcheck {
    test         = ["CMD-SHELL", "pg_isready -U postgres"]
    interval     = "10s"
    timeout      = "5s"
    retries      = 5
    start_period = "30s"
  }
}

# Container da API NodeJS
resource "docker_container" "api" {
  image = docker_image.app_image.image_id
  name  = "devops-api"
  
  networks_advanced {
    name = docker_network.devops_network.name
  }

  env = [
    "DB_HOST=devops-postgres",
    "DB_USER=postgres",
    "DB_PASSWORD=admin",
    "DB_NAME=devops_class",
    "DB_PORT=5432",
    "NODE_ENV=production",
    "PORT=3000"
  ]

  ports {
    internal = 3000
    external = 3000
  }

  # Dependência do container do banco de dados
  depends_on = [docker_container.postgres]

  # Health check
  healthcheck {
    test         = ["CMD", "wget", "--no-verbose", "--tries=1", "--spider", "http://localhost:3000/health"]
    interval     = "30s"
    timeout      = "10s"
    retries      = 3
    start_period = "40s"
  }

  # Restart policy
  restart = "unless-stopped"
}