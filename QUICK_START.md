# Quick Start - Exercício DevOps

Guia rápido para testar a solução implementada.

## 🚀 Opção 1: Docker Local (Mais Rápido)

```bash
# 1. Inicializar Terraform
cd terraform/docker
terraform init

# 2. Aplicar infraestrutura
terraform apply -auto-approve

# 3. Aguardar ~30 segundos e testar
curl http://localhost:3000/cursos
curl http://localhost:3000/alunos

# 4. Ver logs (opcional)
docker logs devops-api -f

# 5. Limpar quando terminar
terraform destroy -auto-approve
cd ../..
```

## ☁️ Opção 2: AWS Cloud

```bash
# 1. Configurar AWS CLI (se ainda não configurou)
aws configure

# 2. Preparar variáveis
cd terraform/aws
cp terraform.tfvars.example terraform.tfvars

# 3. Editar terraform.tfvars (IMPORTANTE!)
# Edite os seguintes valores:
# - git_repo_url: URL do seu fork
# - ssh_public_key: conteúdo de ~/.ssh/id_rsa.pub
# - db_password: uma senha forte
nano terraform.tfvars

# 4. Inicializar Terraform
terraform init

# 5. Aplicar infraestrutura (leva ~10-15 minutos)
terraform apply

# 6. Aguardar inicialização completa (~5 minutos após apply)
# Copie o IP público mostrado nos outputs

# 7. Testar
API_URL=$(terraform output -raw api_url)
curl $API_URL/cursos
curl $API_URL/alunos

# 8. Conectar via SSH (opcional)
ssh -i ~/.ssh/devops-key ubuntu@$(terraform output -raw ec2_public_ip)

# 9. Ver logs (via SSH)
sudo journalctl -u devops-api -f

# 10. IMPORTANTE: Destruir quando terminar para evitar custos
terraform destroy
cd ../..
```

## 🔍 Verificar Pipeline GitHub Actions

```bash
# 1. Adicionar arquivos
git add .

# 2. Commit
git commit -m "Implementação DevOps - CI/CD e IaC"

# 3. Push
git push origin main

# 4. Verificar pipeline
# Vá para: https://github.com/seu-usuario/seu-repo/actions
```

## 📋 Comandos Úteis

### Docker
```bash
# Ver containers
docker ps

# Logs da API
docker logs devops-api -f

# Logs do PostgreSQL
docker logs devops-postgres -f

# Conectar ao banco
docker exec -it devops-postgres psql -U postgres -d devops_class

# Reiniciar API
docker restart devops-api
```

### AWS
```bash
# Ver outputs
terraform output

# IP público
terraform output ec2_public_ip

# URL da API
terraform output api_url

# Conectar SSH
eval $(terraform output ssh_connection)

# Ver logs remotamente
ssh -i ~/.ssh/devops-key ubuntu@$(terraform output -raw ec2_public_ip) \
  "sudo journalctl -u devops-api -n 50"
```

## 🧪 Testar API

```bash
# Definir URL (Docker local)
API_URL="http://localhost:3000"

# Ou para AWS
API_URL=$(cd terraform/aws && terraform output -raw api_url)

# Listar cursos
curl $API_URL/cursos

# Listar alunos
curl $API_URL/alunos

# Criar um curso
curl -X POST $API_URL/cursos \
  -H "Content-Type: application/json" \
  -d '{"nome":"DevOps Pro","descricao":"Curso avançado de DevOps"}'

# Criar um aluno
curl -X POST $API_URL/alunos \
  -H "Content-Type: application/json" \
  -d '{"nome":"João Silva","email":"joao@example.com","curso_id":1}'

# Obter um aluno específico
curl $API_URL/alunos/1

# Atualizar um aluno
curl -X PUT $API_URL/alunos/1 \
  -H "Content-Type: application/json" \
  -d '{"nome":"João da Silva","email":"joao.silva@example.com"}'

# Deletar um aluno
curl -X DELETE $API_URL/alunos/1
```

## 🐛 Troubleshooting Rápido

### Docker: API não responde
```bash
docker logs devops-api
docker logs devops-postgres
docker restart devops-api
```

### AWS: API não responde
```bash
# 1. Verificar se user_data terminou
ssh -i ~/.ssh/devops-key ubuntu@$(terraform output -raw ec2_public_ip)
sudo cat /var/log/cloud-init-output.log

# 2. Verificar serviço
sudo systemctl status devops-api
sudo journalctl -u devops-api -n 50

# 3. Testar conectividade com RDS
psql -h $(terraform output -raw rds_address) -U postgres -d devops_class
```

### GitHub Actions: Pipeline falha
```bash
# Testar localmente primeiro
npm install
npm run lint
npm test

# Se passar local, verificar configuração do workflow
cat .github/workflows/ci.yml
```

## 📚 Documentação Completa

- **Guia Geral**: [DEPLOY.md](DEPLOY.md)
- **Solução Completa**: [SOLUCAO.md](SOLUCAO.md)
- **Docker**: [terraform/docker/README.md](terraform/docker/README.md)
- **AWS**: [terraform/aws/README.md](terraform/aws/README.md)

## ⚠️ Lembretes Importantes

1. **AWS**: Sempre execute `terraform destroy` quando terminar para evitar custos
2. **Secrets**: Nunca commite `terraform.tfvars` (já está no .gitignore)
3. **Chave SSH**: Guarde bem sua chave privada, será necessária para acessar a EC2
4. **Free Tier**: Se é sua primeira vez na AWS, você tem 12 meses de Free Tier
5. **GitHub Actions**: O pipeline roda automaticamente em push/PR para main

## ✅ Checklist de Entrega

- [ ] Fork do repositório criado
- [ ] Pipeline GitHub Actions rodando e passando
- [ ] Uma das opções de infraestrutura testada e funcionando
- [ ] API acessível e respondendo corretamente
- [ ] Pull Request criado do seu fork para o repositório original
- [ ] (AWS) Infraestrutura destruída para evitar custos

## 🎯 Dicas para o Pull Request

No seu Pull Request, inclua:
- Descrição do que foi implementado
- Qual opção você escolheu (Docker, AWS ou ambas)
- Screenshot do pipeline passando
- Screenshot da API respondendo
- Qualquer desafio que enfrentou e como resolveu
