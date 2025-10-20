terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.6.1"
    }
  }
}
provider "docker" {}

resource "docker_network" "devops_net" {
  name = "devops_net"
}

resource "docker_volume" "pg_data" {
  name = "pg_data"
}

resource "docker_container" "postgres" {
  name  = "devops-db"
  image = "postgres:13"
  networks_advanced {
    name = docker_network.devops_net.name
  }
  env = [
    "POSTGRES_USER=admin",
    "POSTGRES_PASSWORD=admin",
    "POSTGRES_DB=devops_class"
  ]
  volumes {
    volume_name    = docker_volume.pg_data.name
    container_path = "/var/lib/postgresql/data"
  }
  ports {
    internal = 5432
    external = 5432
  }
}

# resource "docker_image" "api_image" {
#   name = "devops-api"
#   build {
#     context    = "${path.module}/../../"
#     dockerfile = "${path.module}/../../Dockerfile"
#   }
# }

resource "docker_container" "api" {
  name  = "devops-api"
  image = "devops-api"  # ← usa a imagem já criada
  depends_on = [docker_container.postgres]
  networks_advanced {
    name = docker_network.devops_net.name
  }
  env = [
    "DB_HOST=devops-db",
    "DB_USER=admin",
    "DB_PASSWORD=admin",
    "DB_NAME=devops_class"
  ]
  ports {
    internal = 3000
    external = 3000
  }
}