variable "network_name" {
  description = "O nome da rede Docker."
  type        = string
  default     = "custom_network"
}

variable "volume_name" {
  description = "O nome do volume Docker."
  type        = string
  default     = "custom_volume"
}

variable "postgres_container_name" {
  description = "O nome do container PostgreSQL."
  type        = string
  default     = "postgres_server"
  
}

variable "node_external_port" {
  description = "A porta externa para o container Node.js."
  type        = number
  default     = 3000
  
}

# Variáveis para o container PostgreSQL

variable "postgres_user" {
  description = "O usuário do banco de dados PostgreSQL."
  type        = string
  default     = "postgres"
}

variable "postgres_password" {
  description = "A senha do banco de dados PostgreSQL."
  type        = string
  default     = "admin"
}

variable "postgres_db" {
  description = "O nome do banco de dados PostgreSQL."
  type        = string
  default     = "devops_class"
}

variable "postgres_external_port" {
  description = "A porta externa para o container PostgreSQL."
  type        = number
  default     = 5432
}