variable "db_user" {
  description = "Nome do usuário do banco de dados PostgreSQL"
  type        = string
  default     = "postgres"
}

variable "db_password" {
  description = "Senha do banco de dados PostgreSQL"
  type        = string
  default     = "admin"
  sensitive   = true
}

variable "db_name" {
  description = "Nome do banco de dados"
  type        = string
  default     = "devops_class"
}

variable "app_port" {
  description = "Porta externa para acessar a aplicação"
  type        = number
  default     = 3000
}
