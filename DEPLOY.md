# Guia de Deploy - Exercício DevOps

Este documento descreve como fazer o deploy da aplicação DevOps API usando as duas opções disponíveis.

## Estrutura do Projeto

```
.
├── .github/
│   └── workflows/
│       └── ci.yml              # Pipeline de CI/CD
├── src/                         # Código da aplicação (não alterar)
├── Dockerfile                   # Container da aplicação
├── terraform/
│   ├── docker/                  # Infraestrutura Docker (local)
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── README.md
│   └── aws/                     # Infraestrutura AWS (cloud)
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
│       ├── user_data.sh
│       ├── terraform.tfvars.example
│       └── README.md
└── DEPLOY.md                    # Este arquivo
```

## Opção 1: Deploy Local com Docker

Ideal para desenvolvimento e testes locais.

### Vantagens
- Gratuito
- Rápido para testar
- Não requer conta AWS
- Fácil de destruir e recriar

### Passo a passo

1. **Instalar pré-requisitos**:
   - [Docker Desktop](https://www.docker.com/products/docker-desktop)
   - [Terraform](https://www.terraform.io/downloads)

2. **Executar o deploy**:
   ```bash
   cd terraform/docker
   terraform init
   terraform apply
   ```

3. **Acessar a aplicação**:
   ```bash
   curl http://localhost:3000/alunos
   ```

4. **Documentação completa**: [terraform/docker/README.md](terraform/docker/README.md)

## Opção 2: Deploy na AWS

Ideal para ambientes de produção e para aprender cloud computing.

### Vantagens
- Infraestrutura profissional
- Banco de dados gerenciado (RDS)
- Escalável
- Acessível pela internet

### Custos
- ~$24/mês (ou gratuito com Free Tier no primeiro ano)

### Passo a passo

1. **Instalar pré-requisitos**:
   - [AWS CLI](https://aws.amazon.com/cli/)
   - [Terraform](https://www.terraform.io/downloads)
   - Conta AWS configurada

2. **Configurar credenciais**:
   ```bash
   aws configure
   ```

3. **Preparar variáveis**:
   ```bash
   cd terraform/aws
   cp terraform.tfvars.example terraform.tfvars
   # Edite terraform.tfvars com seus valores
   ```

4. **Executar o deploy**:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

5. **Acessar a aplicação**:
   ```bash
   # Obter URL
   terraform output api_url

   # Testar
   curl $(terraform output -raw api_url)/alunos
   ```

6. **Documentação completa**: [terraform/aws/README.md](terraform/aws/README.md)

## CI/CD Pipeline

O pipeline do GitHub Actions está configurado em `.github/workflows/ci.yml` e executa:

1. **Checkout** do código
2. **Setup** do Node.js 18
3. **Install** das dependências (com cache)
4. **Lint** do código
5. **Testes** de integração com PostgreSQL

### Como funciona

- O pipeline é acionado automaticamente em:
  - Push para a branch `main`
  - Pull Requests para a `main`

- Um container PostgreSQL é iniciado como serviço
- Os testes são executados contra o banco de dados
- O pipeline só passa se todos os testes e lint passarem

### Visualizar o pipeline

Após fazer push para o GitHub, acesse:
```
https://github.com/seu-usuario/seu-repo/actions
```

## Endpoints da API

A API possui os seguintes endpoints:

### Cursos
- `GET /cursos` - Listar todos os cursos
- `GET /cursos/:id` - Obter um curso específico
- `POST /cursos` - Criar um novo curso
- `PUT /cursos/:id` - Atualizar um curso
- `DELETE /cursos/:id` - Deletar um curso

### Alunos
- `GET /alunos` - Listar todos os alunos
- `GET /alunos/:id` - Obter um aluno específico
- `POST /alunos` - Criar um novo aluno
- `PUT /alunos/:id` - Atualizar um aluno
- `DELETE /alunos/:id` - Deletar um aluno

### Exemplos de uso

```bash
# Listar cursos
curl http://localhost:3000/cursos

# Criar um aluno
curl -X POST http://localhost:3000/alunos \
  -H "Content-Type: application/json" \
  -d '{
    "nome": "Maria Santos",
    "email": "maria@example.com",
    "curso_id": 1
  }'

# Atualizar um aluno
curl -X PUT http://localhost:3000/alunos/1 \
  -H "Content-Type: application/json" \
  -d '{
    "nome": "Maria Santos Silva",
    "email": "maria.silva@example.com"
  }'

# Deletar um aluno
curl -X DELETE http://localhost:3000/alunos/1
```

## Comparação das Opções

| Aspecto | Docker (Local) | AWS (Cloud) |
|---------|---------------|-------------|
| **Custo** | Gratuito | ~$24/mês (ou Free Tier) |
| **Setup** | 5 minutos | 15 minutos |
| **Pré-requisitos** | Docker + Terraform | AWS CLI + Terraform + Conta AWS |
| **Acesso** | Apenas local | Internet pública |
| **Banco de dados** | Container | RDS gerenciado |
| **Backup** | Manual | Automático (opcional) |
| **Escalabilidade** | Limitada | Alta |
| **Uso recomendado** | Desenvolvimento | Produção |

## Limpeza (Cleanup)

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

**Importante**: Sempre execute `terraform destroy` quando terminar para evitar custos desnecessários (no caso da AWS).

## Troubleshooting Comum

### Docker: Porta em uso
```bash
# Mudar a porta da API
terraform apply -var="api_port=3001"
```

### AWS: AMI não encontrada
```bash
# Encontrar AMI correto para sua região
aws ec2 describe-images \
  --owners 099720109477 \
  --filters "Name=name,Values=ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*" \
  --query 'sort_by(Images, &CreationDate)[-1].ImageId'
```

### Pipeline GitHub Actions falha
- Verifique se o PostgreSQL service iniciou corretamente
- Verifique se os testes passam localmente
- Veja os logs detalhados na aba Actions do GitHub

## Recursos Adicionais

- [Documentação Terraform](https://www.terraform.io/docs)
- [Documentação Docker](https://docs.docker.com/)
- [Documentação AWS](https://docs.aws.amazon.com/)
- [GitHub Actions](https://docs.github.com/en/actions)

## Suporte

Para dúvidas sobre o exercício, consulte:
- README.md principal do projeto
- Documentação específica em cada diretório terraform/
- Issues do repositório original
