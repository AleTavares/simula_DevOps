# Infraestrutura com Terraform

Este projeto oferece duas opções de infraestrutura:

## Opção A: Docker Local (terraform/docker/)

### Pré-requisitos:
- Docker instalado
- Terraform instalado

### Como usar:
```bash
cd terraform/docker/

# Construir a imagem da aplicação primeiro
docker build -t devops-api:latest ../../

# Inicializar Terraform
terraform init

# Planejar a infraestrutura
terraform plan

# Aplicar a infraestrutura
terraform apply
```

### Acesso:
- API: http://localhost:3000
- PostgreSQL: localhost:5432

## Opção B: AWS Cloud (terraform/aws/)

### Pré-requisitos:
- AWS CLI configurado
- Terraform instalado
- Chave SSH criada (~/.ssh/id_rsa.pub)

### Como usar:
```bash
cd terraform/aws/

# Inicializar Terraform
terraform init

# Planejar a infraestrutura
terraform plan

# Aplicar a infraestrutura
terraform apply
```

### Acesso:
- API: http://[EC2_PUBLIC_IP]:3000
- SSH: ssh -i ~/.ssh/id_rsa ubuntu@[EC2_PUBLIC_IP]

### Limpeza:
```bash
# Para destruir a infraestrutura
terraform destroy
```

## Variáveis de Ambiente

A aplicação usa as seguintes variáveis:
- `DB_HOST`: Host do banco de dados
- `DB_USER`: Usuário do banco
- `DB_PASSWORD`: Senha do banco
- `DB_NAME`: Nome do banco
- `DB_PORT`: Porta do banco (padrão: 5432)