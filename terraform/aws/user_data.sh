#!/bin/bash

# Atualizar o sistema
apt-get update -y
apt-get upgrade -y

# Instalar dependências básicas
apt-get install -y curl wget git postgresql-client

# Instalar Node.js 18
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
apt-get install -y nodejs

# Verificar instalação
node --version
npm --version

# Criar diretório para a aplicação
mkdir -p /opt/devops-app
cd /opt/devops-app

# Clonar o repositório
git clone ${github_repo} .

# Instalar dependências
npm ci --only=production

# Criar arquivo de ambiente
cat > .env << EOF
DB_HOST=${db_host}
DB_USER=${db_user}
DB_PASSWORD=${db_password}
DB_NAME=${db_name}
DB_PORT=5432
NODE_ENV=production
PORT=3000
EOF

# Aguardar o banco de dados ficar disponível
echo "Aguardando banco de dados..."
until pg_isready -h ${db_host} -U ${db_user}; do
    echo "Banco de dados não está pronto. Aguardando..."
    sleep 5
done

# Executar schema do banco de dados
PGPASSWORD=${db_password} psql -h ${db_host} -U ${db_user} -d ${db_name} -f src/database/schema.sql

# Criar serviço systemd para a aplicação
cat > /etc/systemd/system/devops-api.service << EOF
[Unit]
Description=DevOps API NodeJS Application
After=network.target

[Service]
Type=simple
User=ubuntu
WorkingDirectory=/opt/devops-app
Environment=NODE_ENV=production
EnvironmentFile=/opt/devops-app/.env
ExecStart=/usr/bin/npm start
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

# Alterar proprietário dos arquivos
chown -R ubuntu:ubuntu /opt/devops-app

# Habilitar e iniciar o serviço
systemctl daemon-reload
systemctl enable devops-api
systemctl start devops-api

# Instalar e configurar nginx como proxy reverso (opcional, mas recomendado)
apt-get install -y nginx

cat > /etc/nginx/sites-available/devops-api << EOF
server {
    listen 80;
    server_name _;

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_cache_bypass \$http_upgrade;
    }

    location /health {
        proxy_pass http://localhost:3000/health;
        access_log off;
    }
}
EOF

# Habilitar o site
ln -s /etc/nginx/sites-available/devops-api /etc/nginx/sites-enabled/
rm /etc/nginx/sites-enabled/default

# Testar e recarregar nginx
nginx -t && systemctl reload nginx

# Log de conclusão
echo "Setup completo! API rodando na porta 3000" >> /var/log/user-data.log