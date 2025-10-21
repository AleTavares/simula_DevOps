output "postgres_container_id" {
  description = "The ID of the PostgreSQL Docker container"
  value       = docker_container.postgres.id
}
output "node_container_id" {
  description = "The ID of the Node.js Docker container"
  value       = docker_container.node.id
}