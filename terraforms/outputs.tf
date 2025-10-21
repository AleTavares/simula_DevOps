output "api_url" {
  value = "http://localhost:3000"
}

output "postgres_container" {
  value = docker_container.postgres.name
}

