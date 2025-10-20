output "api_url" {
value = "http://localhost:${var.api_port}"
}


output "postgres_container" {
value = docker_container.postgres.name
}