terraform {
    required_providers {
        docker = {
            source  = "kreuzwerker/docker"
            version = "~> 2.13.0"
        }
    }
}

provider "docker" {}

resource "docker_container" "postgres" {
    image = "postgres:13"
    name  = "my_postgres_db"

    env = [
        "POSTGRES_USER=admin",
        "POSTGRES_PASSWORD=admin",
        "POSTGRES_DB=mydatabase"
    ]
    ports {
        internal = 5432
        external = 5432
    }
}

resource "docker_container" "node" {
  
}