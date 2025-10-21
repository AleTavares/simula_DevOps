terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

# Network para comunicação entre containers
resource "docker_network" "devops_network" {
  name = "devops-network"
}

# Volume para persistência dos dados do PostgreSQL
resource "docker_volume" "postgres_data" {
  name = "devops-postgres-data"
}

# Container PostgreSQL
resource "docker_container" "postgres" {
  name  = "devops-postgres"
  image = docker_image.postgres.image_id

  networks_advanced {
    name = docker_network.devops_network.name
  }

  ports {
    internal = 5432
    external = 5432
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

  healthcheck {
    test     = ["CMD-SHELL", "pg_isready -U postgres"]
    interval = "10s"
    timeout  = "5s"
    retries  = 5
  }
}

# Image PostgreSQL
resource "docker_image" "postgres" {
  name = "postgres:13"
}

# Build da imagem da API
resource "docker_image" "api" {
  name = "devops-api:latest"
  build {
    context    = "../../"
    dockerfile = "Dockerfile"
  }
}

# Container da API NodeJS
resource "docker_container" "api" {
  name  = "devops-api"
  image = docker_image.api.image_id

  networks_advanced {
    name = docker_network.devops_network.name
  }

  ports {
    internal = 3000
    external = 3000
  }

  env = [
    "DB_HOST=devops-postgres",
    "DB_USER=postgres",
    "DB_PASSWORD=admin",
    "DB_NAME=devops_class",
    "DB_PORT=5432",
    "PORT=3000"
  ]

  depends_on = [
    docker_container.postgres
  ]

  restart = "unless-stopped"
}

# Execute schema do banco de dados
resource "null_resource" "init_db" {
  depends_on = [docker_container.postgres]

  provisioner "local-exec" {
    command = <<-EOT
      echo "Aguardando PostgreSQL ficar pronto..."
      sleep 10
      echo "Executando schema do banco de dados..."
      cat ../../src/database/schema.sql | docker exec -i devops-postgres psql -U postgres -d devops_class || true
      echo "Schema executado com sucesso!"
    EOT
  }

  triggers = {
    postgres_id = docker_container.postgres.id
  }
}
