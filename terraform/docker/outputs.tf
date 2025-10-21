output "postgres_container_id" {
  description = "ID do contêiner Docker."
  value       = docker_container.postgres_server.id
}

output "postgres_port" {
  description = "Porta para acessar o Postgres."
  value       = var.postgres_external_port
}