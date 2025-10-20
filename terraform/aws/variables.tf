```hcl
variable "region" { default = "us-east-1" }
variable "instance_type" { default = "t2.micro" }
variable "key_name" { description = "SSH key pair name already in AWS" }
variable "db_password" { description = "DB master password" }
variable "db_username" { default = "dev" }