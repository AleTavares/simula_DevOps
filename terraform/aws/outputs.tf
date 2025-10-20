output "api_url" {
  description = "URL da API NodeJS"
  value       = "http://${aws_instance.api_server.public_ip}:3000"
}

output "ssh_connection" {
  description = "Comando SSH para conectar à instância"
  value       = "ssh -i ~/.ssh/devops-key ubuntu@${aws_instance.api_server.public_ip}"
}

output "database_endpoint" {
  description = "Endpoint do banco de dados RDS"
  value       = aws_db_instance.postgres.endpoint
}

output "instance_public_ip" {
  description = "IP público da instância EC2"
  value       = aws_instance.api_server.public_ip
}

output "instance_id" {
  description = "ID da instância EC2"
  value       = aws_instance.api_server.id
}

output "rds_instance_id" {
  description = "ID da instância RDS"
  value       = aws_db_instance.postgres.id
}