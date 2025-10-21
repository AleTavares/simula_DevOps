# Use uma imagem base oficial do Node.js
FROM node:18-slim

# Crie e defina o diretório de trabalho
WORKDIR /usr/src/app

# Copie package.json e package-lock.json e instale dependências
COPY package*.json ./
RUN npm install

# Copie o restante do código
COPY . .

# Exponha a porta da aplicação (ex: 3000)
EXPOSE 3000

# Comando para iniciar a aplicação
CMD [ "npm", "start" ]