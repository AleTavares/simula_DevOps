terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.0"
}

# Configuração do provider AWS
provider "aws" {
  region = var.aws_region
}

# Obter dados da VPC padrão
data "aws_vpc" "default" {
  default = true
}

# Obter subnets da VPC padrão
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Security Group para a instância EC2
resource "aws_security_group" "api_sg" {
  name_prefix = "devops-api-sg"
  vpc_id      = data.aws_vpc.default.id

  # SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # API NodeJS
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # PostgreSQL (para comunicação interna)
  ingress {
    from_port = 5432
    to_port   = 5432
    protocol  = "tcp"
    self      = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "devops-api-security-group"
  }
}

# Security Group para RDS
resource "aws_security_group" "rds_sg" {
  name_prefix = "devops-rds-sg"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.api_sg.id]
  }

  tags = {
    Name = "devops-rds-security-group"
  }
}

# Subnet Group para RDS
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "devops-rds-subnet-group"
  subnet_ids = data.aws_subnets.default.ids

  tags = {
    Name = "devops-rds-subnet-group"
  }
}

# Instância RDS PostgreSQL
resource "aws_db_instance" "postgres" {
  identifier = "devops-postgres"
  
  engine         = "postgres"
  engine_version = "13.13"
  instance_class = "db.t3.micro"
  
  allocated_storage     = 20
  max_allocated_storage = 100
  storage_type          = "gp2"
  
  db_name  = var.postgres_db
  username = var.postgres_user
  password = var.postgres_password
  
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  
  backup_retention_period = 7
  backup_window          = "03:00-04:00"
  maintenance_window     = "sun:04:00-sun:05:00"
  
  skip_final_snapshot = true
  deletion_protection = false
  
  tags = {
    Name = "devops-postgres"
  }
}

# Key Pair para SSH (você deve ter uma chave SSH)
resource "aws_key_pair" "devops_key" {
  key_name   = "devops-key"
  public_key = var.ssh_public_key
}

# Dados da AMI Ubuntu mais recente
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Instância EC2 para a API
resource "aws_instance" "api_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = aws_key_pair.devops_key.key_name
  
  vpc_security_group_ids = [aws_security_group.api_sg.id]
  
  user_data = base64encode(templatefile("${path.module}/user_data.sh", {
    db_host     = aws_db_instance.postgres.endpoint
    db_name     = var.postgres_db
    db_user     = var.postgres_user
    db_password = var.postgres_password
    github_repo = var.github_repo
  }))
  
  tags = {
    Name = "devops-api-server"
  }

  depends_on = [aws_db_instance.postgres]
}