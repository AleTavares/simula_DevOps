# Terraform - Deploy na AWS

Esta configuração provisiona a aplicação DevOps API na AWS usando EC2 e RDS PostgreSQL.

## Pré-requisitos

- [Terraform](https://www.terraform.io/downloads.html) instalado (versão >= 1.0)
- [AWS CLI](https://aws.amazon.com/cli/) instalado e configurado
- Conta AWS com permissões apropriadas
- Par de chaves SSH (gerar com `ssh-keygen` se necessário)

## Arquitetura

A infraestrutura criada inclui:

- **VPC**: Rede virtual privada (10.0.0.0/16)
- **Subnets**: 2 públicas e 2 privadas em AZs diferentes
- **Internet Gateway**: Para acesso à internet
- **Security Groups**: Firewalls para EC2 e RDS
- **RDS PostgreSQL**: Banco de dados gerenciado (db.t3.micro)
- **EC2 Instance**: Servidor da aplicação (t2.micro)
- **Key Pair**: Para acesso SSH

## Custos Estimados

**Atenção**: Esta infraestrutura irá gerar custos na AWS!

Estimativa mensal (us-east-1):
- EC2 t2.micro: ~$8.50/mês (Free Tier: 750h/mês grátis no primeiro ano)
- RDS db.t3.micro: ~$13/mês (Free Tier: 750h/mês grátis no primeiro ano)
- Armazenamento RDS (20GB): ~$2.30/mês
- **Total**: ~$24/mês (ou gratuito com Free Tier no primeiro ano)

## Como usar

### 1. Configurar credenciais AWS

```bash
aws configure
```

Forneça:
- AWS Access Key ID
- AWS Secret Access Key
- Default region (ex: us-east-1)

### 2. Preparar variáveis

Copie o arquivo de exemplo e edite com seus valores:

```bash
cd terraform/aws
cp terraform.tfvars.example terraform.tfvars
nano terraform.tfvars
```

**Importante**: Configure pelo menos:
- `git_repo_url`: URL do seu fork do repositório
- `ssh_public_key`: Conteúdo da sua chave pública SSH (`cat ~/.ssh/id_rsa.pub`)
- `db_password`: Uma senha forte para o banco de dados

### 3. Inicializar Terraform

```bash
terraform init
```

### 4. Visualizar o plano

```bash
terraform plan
```

Revise todos os recursos que serão criados.

### 5. Aplicar a infraestrutura

```bash
terraform apply
```

Digite `yes` quando solicitado. O processo leva cerca de 10-15 minutos.

### 6. Obter informações de acesso

```bash
terraform output
```

Você verá:
- `ec2_public_ip`: IP público da instância
- `api_url`: URL da API
- `ssh_connection`: Comando para conectar via SSH
- `rds_endpoint`: Endpoint do banco de dados

### 7. Testar a aplicação

Aguarde alguns minutos após o `terraform apply` para que o user_data termine de executar.

```bash
# Obter IP público
API_URL=$(terraform output -raw api_url)

# Testar API
curl $API_URL/alunos
curl $API_URL/cursos
```

## Gerenciamento

### Conectar via SSH

```bash
# Use o comando fornecido pelo output
ssh -i ~/.ssh/devops-key ubuntu@<EC2_PUBLIC_IP>
```

### Ver logs da aplicação

```bash
ssh -i ~/.ssh/devops-key ubuntu@<EC2_PUBLIC_IP>
sudo journalctl -u devops-api -f
```

### Verificar status do serviço

```bash
ssh -i ~/.ssh/devops-key ubuntu@<EC2_PUBLIC_IP>
sudo systemctl status devops-api
```

### Reiniciar a aplicação

```bash
ssh -i ~/.ssh/devops-key ubuntu@<EC2_PUBLIC_IP>
sudo systemctl restart devops-api
```

### Conectar ao banco de dados

```bash
# Obter endpoint RDS
RDS_ENDPOINT=$(terraform output -raw rds_address)

# Conectar via EC2 (túnel)
ssh -i ~/.ssh/devops-key ubuntu@<EC2_PUBLIC_IP>
psql -h $RDS_ENDPOINT -U postgres -d devops_class
```

## Atualizações da aplicação

Para atualizar o código da aplicação:

```bash
ssh -i ~/.ssh/devops-key ubuntu@<EC2_PUBLIC_IP>
cd /opt/devops-api
git pull origin main
npm install --production
sudo systemctl restart devops-api
```

## Destruir a infraestrutura

**Importante**: Isso removerá todos os recursos e dados!

```bash
terraform destroy
```

Digite `yes` para confirmar.

## Troubleshooting

### User data não executou

Conecte via SSH e verifique:

```bash
sudo cat /var/log/cloud-init-output.log
```

### Aplicação não responde

Verifique se o user_data terminou de executar:

```bash
sudo tail -f /var/log/cloud-init-output.log
```

Verifique o status do serviço:

```bash
sudo systemctl status devops-api
sudo journalctl -u devops-api -n 50
```

### RDS não conecta

Verifique os security groups:

```bash
# Os security groups devem permitir EC2 -> RDS na porta 5432
aws ec2 describe-security-groups
```

### Erro de AMI ID

O AMI ID varia por região. Para encontrar o ID correto do Ubuntu 22.04 na sua região:

```bash
aws ec2 describe-images \
  --owners 099720109477 \
  --filters "Name=name,Values=ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*" \
  --query 'sort_by(Images, &CreationDate)[-1].ImageId' \
  --output text
```

Atualize o valor de `ami_id` no `terraform.tfvars`.

## Variáveis disponíveis

| Variável | Descrição | Valor Padrão |
|----------|-----------|--------------|
| `aws_region` | Região AWS | `us-east-1` |
| `instance_type` | Tipo da EC2 | `t2.micro` |
| `ami_id` | AMI Ubuntu 22.04 | (específico da região) |
| `db_instance_class` | Tipo do RDS | `db.t3.micro` |
| `db_name` | Nome do banco | `devops_class` |
| `db_username` | Usuário do banco | `postgres` |
| `db_password` | Senha do banco | (obrigatório) |
| `ssh_public_key` | Chave SSH pública | (obrigatório) |
| `git_repo_url` | URL do repositório | (obrigatório) |

## Segurança

**Recomendações para produção**:

1. **Não use senhas padrão**: Sempre use senhas fortes
2. **Restrinja SSH**: Limite o CIDR block do SSH ao seu IP
3. **Use HTTPS**: Adicione um Load Balancer com certificado SSL
4. **Secrets Manager**: Use AWS Secrets Manager para credenciais
5. **Backup**: Habilite backups automáticos no RDS
6. **Monitoring**: Configure CloudWatch Alarms
7. **IAM Roles**: Use IAM roles ao invés de credenciais hardcoded

## Melhorias futuras

- Auto Scaling Group para alta disponibilidade
- Application Load Balancer
- Route53 para DNS customizado
- CloudWatch Logs e Metrics
- AWS Systems Manager para gerenciamento
- CI/CD com CodePipeline ou GitHub Actions deploy
