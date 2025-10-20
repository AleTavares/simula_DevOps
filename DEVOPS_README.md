# DevOps Infrastructure

Este diretório contém toda a infraestrutura como código (IaC) e automação de CI/CD para a aplicação NodeJS.

## Estrutura

```
.github/workflows/    # Pipelines de CI/CD
terraform/
├── docker/          # Infraestrutura local com Docker
└── aws/             # Infraestrutura na AWS
Dockerfile           # Container da aplicação
```

## CI/CD Pipeline

O pipeline de CI/CD está configurado no GitHub Actions (`.github/workflows/ci.yml`) e executa:

1. **Checkout** do código
2. **Setup** do Node.js 18 com cache
3. **Instalação** das dependências
4. **Lint** do código
5. **Testes** de integração com PostgreSQL

### Como funciona:
- Trigger: Push ou PR para a branch `main`
- Ambiente: Ubuntu Latest
- Banco de dados: PostgreSQL 13 como service container
- Cache: NPM dependencies para builds mais rápidos

## Opções de Infraestrutura

### Opção A: Docker (Local)

Para executar localmente com Docker:

```bash
cd terraform/docker

# Inicializar Terraform
terraform init

# Planejar a infraestrutura
terraform plan

# Aplicar a infraestrutura
terraform apply

# Acessar a aplicação
curl http://localhost:3000
```

**O que será criado:**
- Rede Docker para comunicação entre containers
- Volume persistente para dados do PostgreSQL
- Container PostgreSQL 13
- Container da aplicação NodeJS
- Health checks para ambos os containers

### Opção B: AWS (Nuvem)

Para implantar na AWS:

```bash
cd terraform/aws

# Copiar e configurar variáveis
cp terraform.tfvars.example terraform.tfvars
# Editar terraform.tfvars com seus valores

# Inicializar Terraform
terraform init

# Planejar a infraestrutura
terraform plan

# Aplicar a infraestrutura
terraform apply

# A URL da API será exibida no output
```

**O que será criado:**
- Instância EC2 com Ubuntu 20.04
- Instância RDS PostgreSQL 13
- Security Groups para EC2 e RDS
- Key Pair para acesso SSH
- Nginx como proxy reverso
- Serviço systemd para a aplicação

**Requisitos:**
- Credenciais AWS configuradas (`aws configure`)
- Chave SSH pública
- Variáveis preenchidas no `terraform.tfvars`

## Monitoramento e Logs

### Docker
```bash
# Ver logs da aplicação
docker logs devops-api

# Ver logs do banco
docker logs devops-postgres

# Status dos containers
docker ps
```

### AWS
```bash
# Conectar via SSH
ssh -i ~/.ssh/devops-key ubuntu@<IP_PUBLICO>

# Ver logs da aplicação
sudo journalctl -u devops-api -f

# Status do serviço
sudo systemctl status devops-api
```

## Limpeza

### Docker
```bash
cd terraform/docker
terraform destroy
```

### AWS
```bash
cd terraform/aws
terraform destroy
```

## Troubleshooting

### Problemas Comuns

1. **Docker não encontrado**
   - Certifique-se que o Docker está instalado e rodando

2. **Credenciais AWS inválidas**
   - Execute `aws configure` para configurar suas credenciais

3. **Chave SSH inválida**
   - Gere uma nova chave: `ssh-keygen -t rsa -b 4096 -C "seu_email@example.com"`

4. **Banco de dados não conecta**
   - Verifique se o schema foi executado corretamente
   - Confirme as variáveis de ambiente

## Segurança

- Senhas são marcadas como `sensitive` no Terraform
- Uso de Security Groups restritivos na AWS
- Containers rodam com usuário não-root
- Nginx configurado como proxy reverso

## Próximos Passos

- Configurar HTTPS com Let's Encrypt
- Implementar logging centralizado
- Adicionar métricas e alertas
- Configurar auto-scaling
- Implementar Blue/Green deployments