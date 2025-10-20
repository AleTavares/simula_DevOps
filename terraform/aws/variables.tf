variable "aws_region" {
  description = "Região AWS para provisionamento dos recursos"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "Tipo da instância EC2"
  type        = string
  default     = "t2.micro"
}

variable "postgres_user" {
  description = "Usuário do banco de dados PostgreSQL"
  type        = string
  default     = "postgres"
}

variable "postgres_password" {
  description = "Senha do banco de dados PostgreSQL"
  type        = string
  sensitive   = true
}

variable "postgres_db" {
  description = "Nome do banco de dados PostgreSQL"
  type        = string
  default     = "devops_class"
}

variable "ssh_public_key" {
  description = "Chave SSH pública para acesso à instância EC2"
  type        = string
}

variable "github_repo" {
  description = "URL do repositório GitHub (ex: https://github.com/user/repo.git)"
  type        = string
}