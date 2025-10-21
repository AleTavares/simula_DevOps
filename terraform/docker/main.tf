terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
    }
  }
}

provider "docker" {}

resource "docker_network" "devops_network" {
  name = "devops-network"
}

resource "docker_volume" "postgres_data" {
  name = "postgres-data"
}

resource "docker_container" "postgres" {
  image = "postgres:13"
  name  = "devops-postgres"
  env = [
    "POSTGRES_USER=postgres",
    "POSTGRES_PASSWORD=admin",
    "POSTGRES_DB=devops_class"
  ]
  ports {
    internal = 5432
    external = 5432
  }
  volumes {
    volume_name    = docker_volume.postgres_data.name
    container_path = "/var/lib/postgresql/data"
  }
  networks_advanced {
    name = docker_network.devops_network.name
  }
}

resource "docker_container" "nodejs_app" {
  image = "devops-nodejs-app"
  name  = "devops-nodejs-app"
  env = [
    "DB_HOST=devops-postgres",
    "DB_PORT=5432",
    "DB_USER=postgres",
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
  depends_on = [docker_container.postgres]
}