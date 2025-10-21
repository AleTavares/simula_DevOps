terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.2"
    }
  }
}

provider "docker" {}

# 1️⃣ Cria uma rede Docker
resource "docker_network" "app_network" {
  name = "app_network"
}

# 2️⃣ Cria um volume Docker para persistência do PostgreSQL
resource "docker_volume" "postgres_data" {
  name = "postgres_data"
}

# 3️⃣ Container do PostgreSQL
resource "docker_container" "postgres" {
  name  = "postgres_container"
  image = "postgres:13"

  env = [
    "POSTGRES_USER=admin",
    "POSTGRES_PASSWORD=admin123",
    "POSTGRES_DB=meubanco"
  ]

  networks_advanced {
    name = docker_network.app_network.name
  }

  mounts {
    target = "/var/lib/postgresql/data"
    source = docker_volume.postgres_data.name
    type   = "volume"
  }

  ports {
    internal = 5432
    external = 5432
  }
}

# 4️⃣ Constrói a imagem do Node.js (Dockerfile está 2 pastas acima)
resource "docker_image" "node_app_image" {
  name = "node_app_image"

  build {
    context = "/../../"  
    dockerfile = "/../../Dockerfile"
  }
}

# 5️⃣ Container da aplicação Node.js
resource "docker_container" "node_app" {
  name  = "node_app_container"
  image =  docker_image.node_app_image.name

  env = [
    "DB_HOST=postgres_container",
    "DB_USER=admin",
    "DB_PASSWORD=admin123",
    "DB_NAME=meubanco",
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

# 6️⃣ (Opcional) Outputs para exibir informações úteis no terminal
output "app_url" {
  value = "http://localhost:3000"
}

output "postgres_connection" {
  value = "postgres://admin:admin123@localhost:5432/meubanco"
}
