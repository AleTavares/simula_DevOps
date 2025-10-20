# Use Node 18
FROM node:18

# Criar diretório da aplicação
WORKDIR /app

# Copiar package.json e package-lock.json
COPY package*.json ./

# Instalar dependências
RUN npm install

# Copiar o restante dos arquivos
COPY . .

# Expôr a porta da aplicação
EXPOSE 3000

# Rodar o comando para iniciar a API
CMD ["npm", "start"]
