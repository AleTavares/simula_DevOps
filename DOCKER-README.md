# Docker Setup - DevOps Exercise

## Pré-requisitos

- Docker Desktop instalado
- Docker Compose disponível

## Como executar

### Opção 1: Usando o script (Windows)
```bash
# Iniciar aplicação
docker-run.bat up

# Parar aplicação
docker-run.bat down

# Ver logs
docker-run.bat logs

# Reiniciar
docker-run.bat restart

# Limpar tudo
docker-run.bat clean
```

### Opção 2: Comandos Docker Compose diretos
```bash
# Iniciar aplicação
docker-compose up -d --build

# Parar aplicação
docker-compose down

# Ver logs
docker-compose logs -f

# Reiniciar serviços
docker-compose restart
```

## Serviços

- **Aplicação Node.js**: http://localhost:3000
- **PostgreSQL**: localhost:5432
  - Database: `devops_db`
  - User: `devops_user`
  - Password: `devops_password`

## Estrutura

- `Dockerfile`: Configuração da imagem da aplicação
- `docker-compose.yml`: Orquestração dos serviços
- `.dockerignore`: Arquivos ignorados no build
- `docker-run.bat`: Script de gerenciamento (Windows)

## Endpoints da API

- `GET /cursos` - Lista cursos
- `POST /cursos` - Cria curso
- `GET /cursos/:id` - Busca curso por ID
- `PUT /cursos/:id` - Atualiza curso
- `DELETE /cursos/:id` - Remove curso

- `GET /alunos` - Lista alunos
- `POST /alunos` - Cria aluno
- `GET /alunos/:id` - Busca aluno por ID
- `PUT /alunos/:id` - Atualiza aluno
- `DELETE /alunos/:id` - Remove aluno

## Troubleshooting

Se houver problemas:

1. Verificar se o Docker está rodando
2. Verificar se as portas 3000 e 5432 estão livres
3. Executar `docker-run.bat clean` para limpar tudo
4. Tentar novamente com `docker-run.bat up`