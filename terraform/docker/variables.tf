variable "postgres_container_name" {
  description = "Name of the PostgreSQL container"
  type        = string
  default     = "postgres_db"
}

variable "postgres_port" {
  description = "Port for PostgreSQL container"
  type        = number
  default     = 5432
}

variable "node_container_name" {
  description = "Name of the Node.js container"
  type        = string
  default     = "node_app"
}

variable "node_port" {
  description = "Port for Node.js container"
  type        = number
  default     = 3000
}

variable "db_name" {
  description = "Name of the PostgreSQL database"
  type        = string
  default     = "app_db"
}
variable "db_user" {
  description = "Username for the PostgreSQL database"
  type        = string
  default     = "admin"
}
variable "db_password" {
  description = "Password for the PostgreSQL database"
  type        = string
  default     = "password"
}
