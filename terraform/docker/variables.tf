variable "postgres_password" {
  description = "Senha do banco de dados PostgreSQL"
  type        = string
  default     = "admin"
  sensitive   = true
}

variable "postgres_user" {
  description = "Usuário do banco de dados PostgreSQL"
  type        = string
  default     = "postgres"
}

variable "postgres_db" {
  description = "Nome do banco de dados PostgreSQL"
  type        = string
  default     = "devops_class"
}

variable "api_port" {
  description = "Porta externa para a API"
  type        = number
  default     = 3000
}

variable "postgres_port" {
  description = "Porta externa para o PostgreSQL"
  type        = number
  default     = 5432
}