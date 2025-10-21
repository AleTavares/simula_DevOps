
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1" # Use uma versão estável
    }
  }
}

provider "docker" {}



resource "docker_network" "app_network" {
  name = "app_network"
}


resource "docker_volume" "postgres_data" {
  name = "postgres_data"
}



resource "docker_container" "postgres_db" {
  # Nome do container alterado para 'devops-db'
  name  = "devops-db" 
  image = "postgres:13"
  

  env = [
    "POSTGRES_USER=postgres", # Usuário padrão do postgres:13
    "POSTGRES_PASSWORD=admin", # Senha solicitada: admin
    "POSTGRES_DB=devops_class", # Nome do DB solicitado: devops_class
  ]
  

  ports {
    internal = 5432
    external = 5432
  }
  

  volumes {
    volume_name    = docker_volume.postgres_data.name 
    container_path = "/var/lib/postgresql/data"
  }
  
  # Conexão com a rede interna
  networks_advanced {
    name = docker_network.app_network.name
  }
  
  restart = "unless-stopped"
}

resource "docker_container" "app_api" {
  name  = "app-api"
  image = "minha-app-node:latest"
  

  depends_on = [docker_container.postgres_db]
  

  env = [

    "DB_HOST=devops-db", 
    "DB_USER=postgres", # Usuário (POSTGRES_USER)
    "DB_PASSWORD=admin", # Senha (POSTGRES_PASSWORD)
    "DB_NAME=devops_class", # Nome do DB (POSTGRES_DB)
    # Outras variáveis da sua aplicação
    "NODE_ENV=development",
  ]
  
  ports {
    internal = 3000 
    external = 3000 
  }
  

  networks_advanced {
    name = docker_network.app_network.name
  }
  
  restart = "unless-stopped"
}

output "api_endpoint" {
  description = "URL para acessar a API Node.js"
  value       = "http://localhost:${docker_container.app_api.ports[0].external}"
}