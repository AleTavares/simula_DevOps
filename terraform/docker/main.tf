# CONFIGURAÇÃO DO PROVIDER
################################################################################

# Informa ao Terraform para usar o provider do Docker.
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1" # Use uma versão estável
    }
  }
}

provider "docker" {}


# RECURSO 1: REDE PARA COMUNICAÇÃO INTERNA
################################################################################

# Cria uma rede bridge interna para que os containers possam se comunicar 
# usando seus nomes (ex: 'devops-db').
resource "docker_network" "app_network" {
  name = "app_network"
}


# RECURSO 2: VOLUME PARA PERSISTÊNCIA DO BANCO DE DADOS
################################################################################

# Cria um volume persistente no seu host Docker.
resource "docker_volume" "postgres_data" {
  name = "postgres_data"
}


# RECURSO 3: CONTAINER DO POSTGRESQL (BANCO DE DADOS)
################################################################################

resource "docker_container" "postgres_db" {
  # Nome do container alterado para 'devops-db'
  name  = "devops-db" 
  image = "postgres:13"
  
  # Variáveis de ambiente ATUALIZADAS:
  env = [
    "POSTGRES_USER=postgres", # Usuário padrão do postgres:13
    "POSTGRES_PASSWORD=admin", # Senha solicitada: admin
    "POSTGRES_DB=devops_class", # Nome do DB solicitado: devops_class
  ]
  
  # Mapeamento da porta externa (5432:5432) para acesso direto, assim como no comando docker run
  ports {
    internal = 5432
    external = 5432
  }
  
  # Montagem do volume para persistência de dados
  volumes {
    volume_name    = docker_volume.postgres_data.name # <--- O nome do volume criado acima
    container_path = "/var/lib/postgresql/data"
  }
  
  # Conexão com a rede interna
  networks_advanced {
    name = docker_network.app_network.name
  }
  
  restart = "unless-stopped"
}


# RECURSO 4: CONTAINER DA API NODEJS
################################################################################

# ATENÇÃO: Substitua 'minha-app-node:latest' pelo nome exato da imagem que você construiu localmente.
resource "docker_container" "app_api" {
  name  = "app-api"
  image = "minha-app-node:latest"
  
  # Garante que o banco de dados esteja pronto antes de iniciar a API
  depends_on = [docker_container.postgres_db]
  
  # Variáveis de ambiente ATUALIZADAS para se conectar ao DB:
  env = [
    # DB_HOST AGORA usa o novo nome do container: 'devops-db'
    "DB_HOST=devops-db", 
    "DB_USER=postgres", # Usuário (POSTGRES_USER)
    "DB_PASSWORD=admin", # Senha (POSTGRES_PASSWORD)
    "DB_NAME=devops_class", # Nome do DB (POSTGRES_DB)
    # Outras variáveis da sua aplicação
    "NODE_ENV=development",
  ]
  
  # Mapeamento da porta (3000:3000)
  ports {
    internal = 3000 
    external = 3000 
  }
  
  # Conexão com a rede interna
  networks_advanced {
    name = docker_network.app_network.name
  }
  
  restart = "unless-stopped"
}

# OUTPUT (Opcional, mas útil)
################################################################################

# Mostra o endereço para acesso à API no final do 'terraform apply'
output "api_endpoint" {
  description = "URL para acessar a API Node.js"
  value       = "http://localhost:${docker_container.app_api.ports[0].external}"
}