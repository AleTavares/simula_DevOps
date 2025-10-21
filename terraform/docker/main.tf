provider "docker" {}

resource "docker_network" "app_network" {
  name = "app-network"
}

resource "docker_volume" "postgres_data" {
  name = "postgres_data"
}

resource "docker_container" "postgres" {
  name  = "postgres"
  image = "postgres:13"

  env = [
    "POSTGRES_USER=devops",
    "POSTGRES_PASSWORD=admin",
    "POSTGRES_DB=devops_class"
  ]

  volumes {
    volume_name    = docker_volume.postgres_data.name
    container_path = "/var/lib/postgresql/data"
  }

  networks_advanced {
    name = docker_network.app_network.name
  }
}

resource "docker_image" "node_api" {
  name         = "node_api_image"
  build {
    context    = "${path.module}/../../" # caminho para o Dockerfile na raiz do projeto
  }
}

resource "docker_container" "node_api" {
  name  = "node_api"
  image = docker_image.node_api.name

  env = [
    "DB_HOST=postgres",
    "DB_USER=devops",
    "DB_PASSWORD=admin",
    "DB_NAME=devops_class"
  ]

  ports {
    internal = 3000
    external = 3000
  }

  networks_advanced {
    name = docker_network.app_network.name
  }

  depends_on = [
    docker_container.postgres,
    docker_image.node_api
  ]
}
