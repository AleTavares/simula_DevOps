output "ec2_public_ip" {
  description = "IP público da instância EC2"
  value       = aws_instance.app.public_ip
}

output "api_url" {
  description = "URL da API"
  value       = "http://${aws_instance.app.public_ip}:3000"
}

output "rds_endpoint" {
  description = "Endpoint do RDS PostgreSQL"
  value       = aws_db_instance.postgres.endpoint
}

output "rds_address" {
  description = "Endereço do RDS PostgreSQL"
  value       = aws_db_instance.postgres.address
}

output "ssh_connection" {
  description = "Comando SSH para conectar à instância"
  value       = "ssh -i ~/.ssh/devops-key ubuntu@${aws_instance.app.public_ip}"
}
