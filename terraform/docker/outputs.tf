output "postgres_container_name" {
  description = "Nome do container PostgreSQL"
  value       = docker_container.postgres.name
}

output "app_container_name" {
  description = "Nome do container da aplicação"
  value       = docker_container.app.name
}

output "app_url" {
  description = "URL para acessar a aplicação"
  value       = "http://localhost:${var.app_port}"
}

output "network_name" {
  description = "Nome da rede Docker"
  value       = docker_network.app_network.name
}

output "database_info" {
  description = "Informações de conexão com o banco de dados"
  value = {
    host     = "localhost"
    port     = 5432
    database = var.db_name
    user     = var.db_user
  }
  sensitive = false
}
