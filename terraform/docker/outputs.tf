output "app_url" {
  value = "http://localhost:${var.app_port}"
  description = "URL to access the application on the host"
}

output "postgres_container_name" {
  value = docker_container.postgres.name
}