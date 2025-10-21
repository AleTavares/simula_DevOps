terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {}

resource "docker_network" "db_network" {
  name = "my_network"
}

resource "docker_volume" "db_data" {
  name = "postgres_data"
}

resource "docker_container" "postgres" {
  image = "postgres:13"
  name  = "db-postgres"

  ports {
    internal = 5432
    external = 5432
  }

  networks_advanced {
    name = docker_network.db_network.name
  }

  volumes {
    container_path = "/var/lib/postgresql/data"
    volume_name    = docker_volume.db_data.name
  }

  env = [
    "POSTGRES_USER=admin",
    "POSTGRES_PASSWORD=senha123",
    "POSTGRES_DB=meubanco"
  ]
}

resource "docker_container" "api_nodejs" {
  image = "minha-api:latest"
  name  = "api-nodejs"

  ports {
    internal = 3000
    external = 3000
  }

  networks_advanced {
    name = docker_network.db_network.name
  }

  env = [
    "DB_HOST=db-postgres",
    "DB_USER=admin",
    "DB_PASSWORD=senha123",
    "DB_NAME=meubanco"
  ]

  depends_on = [
    docker_container.postgres
  ]
}
