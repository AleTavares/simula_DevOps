terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.2"
    }
  }
}

provider "docker" {}

resource "docker_network" "network" {
  name = var.network_name
  driver = "bridge"
}

resource "docker_volume" "volume" {
  name = var.volume_name
}

resource "docker_container" "postgres_server" {
  name  = var.postgres_container_name
  image = "postgres:13"
  env = [
    "POSTGRES_USER=${var.postgres_user}",
    "POSTGRES_PASSWORD=${var.postgres_password}",
    "POSTGRES_DB=${var.postgres_db}"
  ]
  ports {
    internal = 5432
    external = var.postgres_external_port
  }
  volumes {
    volume_name    = docker_volume.volume.name
    container_path = "/var/lib/postgresql/data"
  }
  volumes {
    host_path      = "${abspath("${path.module}/../../src/database/schema.sql")}"
    container_path = "/init/schema.sql" # Caminho dentro do contêiner
  }
  networks_advanced {
    name = docker_network.network.name
  }
  provisioner "local-exec" {
    command = "sleep 10" # Pode ser necessário ajustar esse tempo
  }
}

resource "null_resource" "init_db" {
  # Garante que o contêiner Docker do PostgreSQL esteja pronto antes
  # e usa o nome correto da sua declaração: docker_container.postgres_server
  depends_on = [docker_container.postgres_server]

  # Executa o script SQL via 'local-exec'
  provisioner "local-exec" {
    # Usando a variável do nome do contêiner e as variáveis de usuário/DB
    command = <<-EOT
      docker exec -i ${var.postgres_container_name} psql -U ${var.postgres_user} -d ${var.postgres_db} -f /init/schema.sql
    EOT

    # Executa o comando apenas na criação
    when = create
  }
}

# resource "docker_image" "node_api_image" {
#     name = "node:18"
#     build {
#         context = "${path.root}/images_docker"
#         dockerfile = "Dockerfile"
#     }
# }

resource "docker_container" "node_api" {
    depends_on = [ docker_container.postgres_server ]
    name  = "node_api"
    image = "node:18"
    env = [
    "POSTGRES_USER=${var.postgres_user}",
    "POSTGRES_PASSWORD=${var.postgres_password}",
    "POSTGRES_DB=${var.postgres_db}"
    ]
    ports {
        internal = 3000
        external = var.node_external_port
    }
    networks_advanced {
        name = docker_network.network.name
    }
}