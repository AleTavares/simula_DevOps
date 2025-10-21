terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

provider "docker" {}

resource "docker_network" "api_network" {
  name = "api_network"
}

resource "docker_volume" "pg_data" {
  name = "pg_data"
}

resource "docker_container" "postgres" {
  image = "postgres:13"
  name  = "postgres_container"
  env = [
    "POSTGRES_USER=admin",
    "POSTGRES_PASSWORD=admin",
    "POSTGRES_DB=escola"
  ]
  networks_advanced {
    name = docker_network.api_network.name
  }
  volumes {
    volume_name    = docker_volume.pg_data.name
    container_path = "/var/lib/postgresql/data"
  }
}

resource "docker_image" "api" {
  name = "api-node"
  build {
    context    = "../.."
    dockerfile = "../..//Dockerfile"
  }
}

resource "docker_container" "api" {
  name  = "api_node"
  image = docker_image.api.name
  networks_advanced {
    name = docker_network.api_network.name
  }
  env = [
    "DB_HOST=postgres_container",
    "DB_USER=admin",
    "DB_PASSWORD=admin",
    "DB_NAME=escola"
  ]
  ports {
    internal = 3000
    external = 3000
  }
  depends_on = [docker_container.postgres]
}
