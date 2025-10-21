variable "postgres_user" {
  description = "Usuário do PostgreSQL"
  type        = string
  default     = "postgres"
}

variable "postgres_password" {
  description = "Senha do PostgreSQL"
  type        = string
  default     = "admin"
  sensitive   = true
}

variable "postgres_db" {
  description = "Nome do banco de dados"
  type        = string
  default     = "devops_class"
}

variable "api_port" {
  description = "Porta externa da API"
  type        = number
  default     = 3000
}
