#!/bin/bash
set -e

# Atualizar sistema
apt-get update
apt-get upgrade -y

# Instalar Node.js 18.x
curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
apt-get install -y nodejs

# Instalar Git e PostgreSQL client
apt-get install -y git postgresql-client

# Criar diretório da aplicação
mkdir -p /opt/devops-api
cd /opt/devops-api

# Clonar repositório
git clone ${git_repo} .

# Instalar dependências
npm install --production

# Configurar variáveis de ambiente
cat > /opt/devops-api/.env << EOF
DB_HOST=${db_host}
DB_USER=${db_user}
DB_PASSWORD=${db_password}
DB_NAME=${db_name}
DB_PORT=${db_port}
PORT=3000
EOF

# Aguardar banco de dados estar pronto
echo "Aguardando banco de dados..."
for i in {1..30}; do
  if PGPASSWORD=${db_password} psql -h ${db_host} -U ${db_user} -d ${db_name} -c "SELECT 1" > /dev/null 2>&1; then
    echo "Banco de dados pronto!"
    break
  fi
  echo "Tentativa $i: Banco de dados não está pronto ainda..."
  sleep 10
done

# Executar schema do banco de dados
PGPASSWORD=${db_password} psql -h ${db_host} -U ${db_user} -d ${db_name} -f /opt/devops-api/src/database/schema.sql

# Criar serviço systemd
cat > /etc/systemd/system/devops-api.service << EOF
[Unit]
Description=DevOps API NodeJS
After=network.target

[Service]
Type=simple
User=ubuntu
WorkingDirectory=/opt/devops-api
EnvironmentFile=/opt/devops-api/.env
ExecStart=/usr/bin/node /opt/devops-api/src/server.js
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

# Iniciar serviço
systemctl daemon-reload
systemctl enable devops-api
systemctl start devops-api

echo "API DevOps instalada e iniciada com sucesso!"
