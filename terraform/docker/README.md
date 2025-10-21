# Terraform - Deploy com Docker (Local)

Esta configuração provisiona a aplicação DevOps API e o banco de dados PostgreSQL usando containers Docker localmente.

## Pré-requisitos

- [Docker](https://docs.docker.com/get-docker/) instalado e rodando
- [Terraform](https://www.terraform.io/downloads.html) instalado (versão >= 1.0)

## Arquitetura

A infraestrutura criada inclui:

- **Docker Network**: Rede para comunicação entre containers
- **Docker Volume**: Volume persistente para dados do PostgreSQL
- **Container PostgreSQL**: Banco de dados (porta 5432)
- **Container API**: Aplicação NodeJS (porta 3000)
- **Inicialização automática**: O schema do banco é executado automaticamente após a criação

## Como usar

### 1. Inicializar Terraform

```bash
cd terraform/docker
terraform init
```

### 2. Visualizar o plano de execução

```bash
terraform plan
```

### 3. Aplicar a infraestrutura

```bash
terraform apply
```

Digite `yes` quando solicitado para confirmar a criação dos recursos.

### 4. Verificar a aplicação

Após o deploy, a API estará disponível em:

```
http://localhost:3000
```

Teste os endpoints:

```bash
# Listar alunos
curl http://localhost:3000/alunos

# Listar cursos
curl http://localhost:3000/cursos

# Criar um aluno
curl -X POST http://localhost:3000/alunos \
  -H "Content-Type: application/json" \
  -d '{"nome":"João Silva","email":"joao@example.com","curso_id":1}'
```

### 5. Visualizar outputs

```bash
terraform output
```

Isso mostrará informações importantes como:
- URL da API
- IDs dos containers
- Host do PostgreSQL

## Gerenciamento

### Ver logs da aplicação

```bash
docker logs devops-api -f
```

### Ver logs do banco de dados

```bash
docker logs devops-postgres -f
```

### Conectar ao banco de dados

```bash
docker exec -it devops-postgres psql -U postgres -d devops_class
```

### Reiniciar a aplicação

```bash
docker restart devops-api
```

## Destruir a infraestrutura

Para remover todos os recursos criados:

```bash
terraform destroy
```

**Atenção**: Isso removerá os containers e o volume do banco de dados (perda de dados).

## Troubleshooting

### Porta já em uso

Se a porta 3000 ou 5432 já estiver em uso, você pode modificar no arquivo `variables.tf` ou passar como variável:

```bash
terraform apply -var="api_port=3001"
```

### Container não inicia

Verifique os logs:

```bash
docker logs devops-api
docker logs devops-postgres
```

### Rebuild da imagem

Se fez alterações no Dockerfile:

```bash
terraform taint docker_image.api
terraform apply
```

## Variáveis disponíveis

| Variável | Descrição | Valor Padrão |
|----------|-----------|--------------|
| `postgres_user` | Usuário do PostgreSQL | `postgres` |
| `postgres_password` | Senha do PostgreSQL | `admin` |
| `postgres_db` | Nome do banco de dados | `devops_class` |
| `api_port` | Porta externa da API | `3000` |

Para usar valores customizados, crie um arquivo `terraform.tfvars`:

```hcl
postgres_password = "minha-senha-segura"
api_port          = 3001
```
