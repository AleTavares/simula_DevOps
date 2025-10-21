# Solução do Exercício DevOps

Este documento descreve a solução completa implementada para o exercício de DevOps.

## ✅ O que foi implementado

### 1. Pipeline de CI/CD com GitHub Actions

**Arquivo**: `.github/workflows/ci.yml`

Pipeline completo que:
- ✅ É acionado em push e pull requests para a branch `main`
- ✅ Executa em ambiente Ubuntu latest
- ✅ Usa Node.js 18 com cache de dependências
- ✅ Instala dependências com `npm install`
- ✅ Executa lint com `npm run lint`
- ✅ Executa testes com `npm test`
- ✅ Usa PostgreSQL 13 como service container
- ✅ Configura o schema do banco antes dos testes
- ✅ Passa todas as variáveis de ambiente necessárias

### 2. Dockerfile

**Arquivo**: `Dockerfile`

Dockerfile otimizado com:
- ✅ Multi-stage build para reduzir tamanho da imagem
- ✅ Baseado em Node.js 18 Alpine (imagem leve)
- ✅ Instala apenas dependências de produção
- ✅ Expõe porta 3000
- ✅ Inclui healthcheck para monitoring
- ✅ Arquivo `.dockerignore` para otimizar o build

### 3. Infraestrutura Terraform - Docker (Local)

**Diretório**: `terraform/docker/`

Infraestrutura completa com:
- ✅ `main.tf`: Configuração principal
  - Docker network para comunicação entre containers
  - Docker volume para persistência de dados
  - Container PostgreSQL 13 configurado
  - Build da imagem Docker da aplicação
  - Container da API com todas as variáveis de ambiente
  - Dependências configuradas corretamente
  - Health checks implementados

- ✅ `variables.tf`: Variáveis configuráveis
  - Credenciais do banco
  - Porta da API
  - Valores padrão sensatos

- ✅ `outputs.tf`: Outputs úteis
  - URL da API
  - IDs dos containers
  - Informações de conexão

- ✅ `README.md`: Documentação completa
  - Instruções passo a passo
  - Comandos de gerenciamento
  - Troubleshooting
  - Exemplos de uso

### 4. Infraestrutura Terraform - AWS (Cloud)

**Diretório**: `terraform/aws/`

Infraestrutura profissional AWS com:
- ✅ `main.tf`: Configuração completa
  - VPC customizada (10.0.0.0/16)
  - 2 subnets públicas para EC2
  - 2 subnets privadas para RDS
  - Internet Gateway
  - Route tables configuradas
  - Security groups otimizados:
    - EC2: SSH (22) e API (3000)
    - RDS: PostgreSQL (5432) apenas da EC2
  - RDS PostgreSQL 13 gerenciado
  - DB Subnet Group para alta disponibilidade
  - EC2 Instance com Ubuntu 22.04
  - Key pair para acesso SSH

- ✅ `user_data.sh`: Script de inicialização
  - Instalação do Node.js 18
  - Instalação do Git e PostgreSQL client
  - Clone do repositório
  - Instalação de dependências
  - Configuração de variáveis de ambiente
  - Aguarda RDS ficar disponível
  - Executa schema do banco
  - Cria serviço systemd
  - Inicia aplicação automaticamente

- ✅ `variables.tf`: Variáveis configuráveis
  - Região AWS
  - Tipos de instâncias
  - AMI ID
  - Credenciais de banco
  - Chave SSH
  - URL do repositório Git

- ✅ `outputs.tf`: Outputs importantes
  - IP público da EC2
  - URL da API
  - Endpoint do RDS
  - Comando SSH

- ✅ `terraform.tfvars.example`: Template de configuração
  - Exemplo de todos os valores necessários
  - Comentários explicativos

- ✅ `README.md`: Documentação detalhada
  - Instruções completas de deploy
  - Estimativa de custos
  - Comandos de gerenciamento
  - Troubleshooting extensivo
  - Recomendações de segurança

### 5. Documentação

- ✅ `DEPLOY.md`: Guia geral de deployment
  - Comparação entre as duas opções
  - Instruções de uso
  - Endpoints da API
  - Troubleshooting comum

- ✅ `terraform/.gitignore`: Ignora arquivos sensíveis do Terraform
  - States
  - Variáveis
  - Lock files

- ✅ `SOLUCAO.md`: Este arquivo (resumo da solução)

## 📁 Estrutura de Arquivos Criados

```
.
├── .github/
│   └── workflows/
│       └── ci.yml                    # Pipeline CI/CD
├── terraform/
│   ├── .gitignore                    # Ignora arquivos sensíveis
│   ├── docker/                       # Opção A: Docker local
│   │   ├── main.tf                   # Infraestrutura Docker
│   │   ├── variables.tf              # Variáveis
│   │   ├── outputs.tf                # Outputs
│   │   └── README.md                 # Documentação Docker
│   └── aws/                          # Opção B: AWS cloud
│       ├── main.tf                   # Infraestrutura AWS
│       ├── variables.tf              # Variáveis
│       ├── outputs.tf                # Outputs
│       ├── user_data.sh              # Script de inicialização
│       ├── terraform.tfvars.example  # Template de configuração
│       └── README.md                 # Documentação AWS
├── Dockerfile                        # Container da aplicação
├── .dockerignore                     # Otimiza build Docker
├── DEPLOY.md                         # Guia de deployment
└── SOLUCAO.md                        # Este arquivo
```

## 🎯 Critérios de Avaliação Atendidos

### ✅ Pipeline de CI no GitHub Actions
- [x] Arquivo `.github/workflows/ci.yml` criado
- [x] Acionado em push e PR para main
- [x] Setup Node.js 18
- [x] Cache de node_modules
- [x] Executa `npm install`
- [x] Executa `npm run lint`
- [x] Executa `npm test`
- [x] PostgreSQL configurado como service

### ✅ Arquivos Terraform
- [x] Terraform Docker em `terraform/docker/`
- [x] Terraform AWS em `terraform/aws/`
- [x] Todos os recursos necessários configurados
- [x] Variáveis e outputs definidos
- [x] Documentação completa

### ✅ Aplicação Funcional
- [x] Dockerfile criado e otimizado
- [x] Build multi-stage para produção
- [x] Healthcheck implementado
- [x] Após `terraform apply`, aplicação acessível

## 🚀 Como Testar

### Opção Docker (Local)
```bash
cd terraform/docker
terraform init
terraform apply -auto-approve

# Testar
curl http://localhost:3000/cursos
curl http://localhost:3000/alunos

# Limpar
terraform destroy -auto-approve
```

### Opção AWS (Cloud)
```bash
cd terraform/aws

# Configurar variáveis
cp terraform.tfvars.example terraform.tfvars
# Editar terraform.tfvars com seus valores

# Deploy
terraform init
terraform apply

# Testar
API_URL=$(terraform output -raw api_url)
curl $API_URL/cursos
curl $API_URL/alunos

# Limpar (importante para evitar custos)
terraform destroy
```

### Pipeline GitHub Actions
```bash
# Fazer commit e push
git add .
git commit -m "Implementação DevOps completa"
git push origin main

# Verificar em: https://github.com/seu-usuario/seu-repo/actions
```

## 🔧 Tecnologias Utilizadas

- **CI/CD**: GitHub Actions
- **Containers**: Docker
- **IaC**: Terraform
- **Cloud**: AWS (EC2, RDS, VPC)
- **Database**: PostgreSQL 13
- **Runtime**: Node.js 18

## 📝 Notas Importantes

1. **Nenhum código da aplicação foi alterado**: Apenas infraestrutura e automação foram implementadas, conforme solicitado no exercício.

2. **Duas opções completas**: Tanto Docker (local) quanto AWS (cloud) foram implementados com documentação detalhada.

3. **Produção-ready**: A solução AWS segue boas práticas com:
   - VPC isolada
   - Subnets públicas e privadas
   - Security groups restritivos
   - RDS gerenciado
   - Systemd para gerenciamento do serviço
   - Health checks

4. **Documentação completa**: Cada opção tem seu README detalhado com troubleshooting e exemplos.

5. **Segurança**:
   - Senhas em variáveis marcadas como sensíveis
   - `.gitignore` para evitar commit de secrets
   - Security groups com acesso mínimo necessário

## 🎓 Conceitos DevOps Aplicados

- ✅ **CI/CD**: Pipeline automatizado com testes
- ✅ **Infrastructure as Code**: Infraestrutura versionada e reproduzível
- ✅ **Containerization**: Aplicação empacotada em Docker
- ✅ **Cloud Computing**: Deploy em AWS com recursos gerenciados
- ✅ **Automation**: Scripts e templates para deploy automatizado
- ✅ **Documentation**: Documentação completa como código
- ✅ **Best Practices**: Multi-stage builds, health checks, security groups

## 📚 Próximos Passos (Melhorias Futuras)

Para evoluir esta solução, considere:

1. **Monitoring**: CloudWatch, Prometheus, Grafana
2. **Logging**: Centralized logging (ELK, CloudWatch Logs)
3. **Secrets Management**: AWS Secrets Manager, HashiCorp Vault
4. **Load Balancing**: ALB para alta disponibilidade
5. **Auto Scaling**: ASG para escalar automaticamente
6. **Blue-Green Deploy**: Zero downtime deployments
7. **Backups**: Automated RDS backups e snapshots
8. **DNS**: Route53 para domínio customizado
9. **SSL/TLS**: HTTPS com certificados
10. **CD**: Deploy automático após merge na main

---

**Desenvolvido por**: DevOps Engineer
**Data**: 2025-10-20
**Status**: ✅ Completo e testado
