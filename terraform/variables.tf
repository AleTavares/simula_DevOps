# Variáveis para o banco de dados PostgreSQL
variable "db_user" {
  description = "Usuário do banco de dados PostgreSQL"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "Senha do banco de dados PostgreSQL"
  type        = string
  sensitive   = true
  default     = "senha123"
}

variable "db_name" {
  description = "Nome do banco de dados"
  type        = string
  default     = "devops_teste"
}

# Variáveis para a aplicação Node.js
variable "api_image_name" {
  description = "Nome da imagem Docker da API"
  type        = string
  default     = "devops-teste-nodejs"
}

variable "api_image_tag" {
  description = "Tag da imagem Docker da API"
  type        = string
  default     = "latest"
}

variable "api_port" {
  description = "Porta da aplicação Node.js"
  type        = number
  default     = 3000
}

variable "db_port" {
  description = "Porta do PostgreSQL"
  type        = number
  default     = 5432
}

# Variáveis para a rede Docker
variable "network_name" {
  description = "Nome da rede Docker"
  type        = string
  default     = "app-network"
}

variable "volume_name" {
  description = "Nome do volume Docker para persistência"
  type        = string
  default     = "postgres-data"
}

# Variáveis para nomes dos containers
variable "postgres_container_name" {
  description = "Nome do container PostgreSQL"
  type        = string
  default     = "devops-teste-db"
}

variable "api_container_name" {
  description = "Nome do container da API"
  type        = string
  default     = "devops-teste-node-api"
}


# caso queira sobrescrever o  valor default  das variaveis, criar um terraform.tfvars
# db_user     = "meu_usuario"
# db_password = "minha_senha_segura"
# db_name     = "minha_aplicacao"
# api_port    = 3000