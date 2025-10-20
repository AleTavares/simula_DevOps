variable "app_image" {
  description = "Name (and tag) of the Docker image for the Node app. Build locally before terraform apply, e.g. 'devops-exercise:latest'"
  type        = string
  default     = "devops-exercise:latest"
}

variable "db_user" {
  type    = string
  default = "admin"
}

variable "db_password" {
  type    = string
  default = "admin"
}

variable "db_name" {
  type    = string
  default = "devops_class"
}

variable "app_port" {
  type    = number
  default = 3000
}