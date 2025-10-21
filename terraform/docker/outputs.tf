output "api_url" {
  description = "URL da API"
  value       = "http://localhost:3000"
}

output "postgres_host" {
  description = "Host do PostgreSQL"
  value       = "localhost:5432"
}

output "api_container_id" {
  description = "ID do container da API"
  value       = docker_container.api.id
}

output "postgres_container_id" {
  description = "ID do container do PostgreSQL"
  value       = docker_container.postgres.id
}
