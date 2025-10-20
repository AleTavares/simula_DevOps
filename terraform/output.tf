# Informações da rede
output "network_name" {
  description = "Nome da rede Docker criada"
  value       = docker_network.app_network.name
}

output "network_id" {
  description = "ID da rede Docker"
  value       = docker_network.app_network.id
}

# Informações do banco de dados
output "postgres_container_info" {
  description = "Informações do container PostgreSQL"
  value = {
    name       = docker_container.postgres.name
    id         = docker_container.postgres.id
    image      = docker_container.postgres.image
    # status removido porque não existe
    ip_address = docker_container.postgres.network_data[0].ip_address
    port       = "${docker_container.postgres.ports[0].external}:${docker_container.postgres.ports[0].internal}"
  }
}

output "database_connection_string" {
  description = "String de conexão com o banco de dados"
  value       = "postgresql://${var.db_user}:${var.db_password}@localhost:${var.db_port}/${var.db_name}"
  sensitive   = true
}

# Informações da API
output "api_container_info" {
  description = "Informações do container da API"
  value = {
    name       = docker_container.api.name
    id         = docker_container.api.id
    image      = docker_container.api.image
    # status removido porque não existe
    ip_address = docker_container.api.network_data[0].ip_address
  }
}

output "api_url" {
  description = "URL para acessar a API"
  value       = "http://localhost:${var.api_port}"
}

output "api_health_check" {
  description = "URL para health check da API"
  value       = "http://localhost:${var.api_port}/health"
}

# Informações do volume
output "volume_info" {
  description = "Informações do volume de persistência"
  value = {
    name       = docker_volume.db_data.name
    mountpoint = docker_volume.db_data.mountpoint
  }
}

# Status da aplicação - ajustado para não usar atributo 'status'
output "application_status" {
  description = "Status resumido da aplicação"
  value = {
    # Como não tem status direto, deixei só o endpoint e portas para você validar externamente
    api_endpoint  = "http://localhost:${var.api_port}"
    database_port = var.db_port
  }
}

# Comandos úteis (comentados)
# output "useful_commands" {
#   description = "Comandos úteis para gerenciar a aplicação"
#   value = {
#     check_containers = "docker ps"
#     check_logs_api   = "docker logs ${var.api_container_name}"
#     check_logs_db    = "docker logs ${var.postgres_container_name}"
#     connect_db       = "PGPASSWORD=${var.db_password} psql -h localhost -U ${var.db_user} -d ${var.db_name}"
#     stop_application = "terraform destroy"
#   }
#   sensitive = false
# }
