# API de Gestão Escolar - DevOps

API REST para gestão de cursos e alunos com implementação completa de DevOps usando Docker.

## 🚀 Tecnologias

- **Backend**: Node.js + Express
- **Banco de dados**: PostgreSQL
- **Containerização**: Docker + Docker Compose
- **Testes**: Jest + Supertest

## 📋 Pré-requisitos

- Docker
- Docker Compose

## 🔧 Instalação e Execução

### Ambiente de Produção

```bash
# Clonar o repositório
git clone <repository-url>
cd NOTA-DEVOPS

# Executar com Docker Compose
docker-compose up -d

# Verificar logs
docker-compose logs -f
```

### Ambiente de Desenvolvimento

```bash
# Executar em modo desenvolvimento (com hot reload)
docker-compose -f docker-compose.dev.yml up -d

# Instalar dependências localmente (opcional)
npm install

# Executar testes
npm test
```

## 🌐 Endpoints da API

### Cursos
- `GET /cursos` - Listar todos os cursos
- `GET /cursos/:id` - Buscar curso por ID
- `POST /cursos` - Criar novo curso
- `PUT /cursos/:id` - Atualizar curso
- `DELETE /cursos/:id` - Deletar curso

### Alunos
- `GET /alunos` - Listar todos os alunos
- `GET /alunos/:id` - Buscar aluno por ID
- `POST /alunos` - Criar novo aluno
- `PUT /alunos/:id` - Atualizar aluno
- `DELETE /alunos/:id` - Deletar aluno

## 📊 Testando a API

```bash
# Criar um curso
curl -X POST http://localhost:3000/cursos \
  -H "Content-Type: application/json" \
  -d '{"nome": "JavaScript", "descricao": "Curso de JavaScript"}'

# Listar cursos
curl http://localhost:3000/cursos

# Criar um aluno
curl -X POST http://localhost:3000/alunos \
  -H "Content-Type: application/json" \
  -d '{"nome": "João Silva", "email": "joao@email.com", "curso_id": 1}'
```

## 🧪 Executando Testes

```bash
# Testes unitários e de integração
docker-compose exec app npm test

# Ou localmente (após npm install)
npm test
```

## 🐳 Comandos Docker Úteis

```bash
# Parar todos os serviços
docker-compose down

# Rebuild das imagens
docker-compose build --no-cache

# Ver logs em tempo real
docker-compose logs -f app

# Acessar container da aplicação
docker-compose exec app sh

# Limpar volumes (cuidado: apaga dados do banco)
docker-compose down -v
```

## 📁 Estrutura do Projeto

```
NOTA-DEVOPS/
├── src/
│   ├── controllers/     # Controladores da API
│   ├── database/        # Configuração do banco
│   ├── routes/          # Rotas da API
│   ├── app.js          # Configuração do Express
│   └── server.js       # Servidor principal
├── tests/
│   ├── unit/           # Testes unitários
│   └── integration/    # Testes de integração
├── docker-compose.yml      # Produção
├── docker-compose.dev.yml  # Desenvolvimento
├── Dockerfile             # Imagem de produção
├── Dockerfile.dev         # Imagem de desenvolvimento
└── init.sql              # Script de inicialização do DB
```

## 🔧 Configuração

As variáveis de ambiente são configuradas no docker-compose.yml:

- `NODE_ENV`: Ambiente (development/production)
- `DB_HOST`: Host do banco de dados
- `DB_PORT`: Porta do banco de dados
- `DB_NAME`: Nome do banco de dados
- `DB_USER`: Usuário do banco
- `DB_PASSWORD`: Senha do banco

## 📈 Próximos Passos

- [ ] Implementar CI/CD com GitHub Actions
- [ ] Adicionar monitoramento com Prometheus
- [ ] Implementar logs estruturados
- [ ] Adicionar autenticação JWT
- [ ] Deploy em Kubernetes