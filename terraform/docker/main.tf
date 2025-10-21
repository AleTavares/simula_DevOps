terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.16"
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
  name    = "devops-postgres"
  image   = "postgres:13"
  restart = "always"

  env = [
    "POSTGRES_USER=devops",
    "POSTGRES_PASSWORD=admin",
    "POSTGRES_DB=devops_class"
  ]

  volumes {
    volume_name    = docker_volume.pgdata.name
    container_path = "/var/lib/postgresql/data"
  }

  networks_advanced {
    name = docker_network.devops_network.name
  }

  ports {
    internal = 5432
    external = 5432
  }
}

resource "docker_image" "nodeapi_image" {
  name = "devops-nodeapi:latest"
  build {
    context    = "${path.module}/../../../.."
    dockerfile = "${path.module}/../../../..//Dockerfile"
  }
}


resource "docker_container" "nodeapi" {
  name    = "devops-nodeapi"
  image   = docker_image.nodeapi_image.name
  restart = "always"

  env = [
    "DB_HOST=devops-postgres",
    "DB_USER=devops",
    "DB_PASSWORD=admin",
    "DB_NAME=devops_class",
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
}
