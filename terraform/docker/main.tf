terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {}

resource "docker_network" "devops_network" {
  name = "devops_network"
}

resource "docker_volume" "pgdata" {
  name = "pgdata"
}

resource "docker_container" "postgres" {
  name  = "devops_postgres"
  image = "postgres:13"
  restart = "always"

  env = [
    "POSTGRES_USER=admin",
    "POSTGRES_PASSWORD=admin",
    "POSTGRES_DB=devops_class"
  ]

  ports {
    internal = 5432
    external = 5432
  }

  volumes {
    volume_name    = docker_volume.pgdata.name
    container_path = "/var/lib/postgresql/data"
  }

  networks_advanced {
    name = docker_network.devops_network.name
  }
}

resource "docker_image" "node_api" {
  name = "devops_node_api:latest"
  build {
    context    = "${path.module}/../../"
    dockerfile = "${path.module}/../../Dockerfile"
  }
}

resource "docker_container" "api" {
  name  = "devops_node_api"
  image = docker_image.node_api.latest
  restart = "always"

  env = [
    "DB_HOST=devops_postgres",
    "DB_USER=admin",
    "DB_PASSWORD=admin",
    "DB_NAME=devops_class"
  ]

  ports {
    internal = 3000
    external = 3000
  }

  networks_advanced {
    name = docker_network.devops_network.name
  }

  depends_on = [
    docker_container.postgres,
    docker_image.node_api
  ]
}
