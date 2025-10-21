variable "aws_region" {
  description = "Região AWS"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "Tipo da instância EC2"
  type        = string
  default     = "t2.micro"
}

variable "ami_id" {
  description = "ID da AMI Ubuntu (varia por região)"
  type        = string
  default     = "ami-0c7217cdde317cfec" # Ubuntu 22.04 LTS em us-east-1
}

variable "db_instance_class" {
  description = "Classe da instância RDS"
  type        = string
  default     = "db.t3.micro"
}

variable "db_name" {
  description = "Nome do banco de dados"
  type        = string
  default     = "devops_class"
}

variable "db_username" {
  description = "Usuário do banco de dados"
  type        = string
  default     = "postgres"
}

variable "db_password" {
  description = "Senha do banco de dados"
  type        = string
  sensitive   = true
  default     = "admin123456"
}

variable "ssh_public_key" {
  description = "Chave SSH pública para acesso à EC2"
  type        = string
  default     = ""
}

variable "git_repo_url" {
  description = "URL do repositório Git"
  type        = string
  default     = "https://github.com/seu-usuario/simula_DevOps.git"
}
