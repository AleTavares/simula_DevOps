output "api_url" {
  description = "URL da API NodeJS"
  value       = "http://localhost:3000"
}

output "database_connection" {
  description = "Informações de conexão do banco de dados"
  value = {
    host     = "localhost"
    port     = 5432
    database = "devops_class"
    username = "postgres"
  }
  sensitive = false
}

output "containers_status" {
  description = "Status dos containers criados"
  value = {
    postgres_container = docker_container.postgres.name
    api_container     = docker_container.api.name
    network_name      = docker_network.devops_network.name
  }
}