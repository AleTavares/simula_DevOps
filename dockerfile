FROM node:latest

# Diretório de trabalho no container
WORKDIR /usr/src/app

# Copiar package.json e package-lock.json
COPY package*.json ./

# Instalar dependências
RUN npm install

# Copiar todo o código da API
COPY . .

# Expor a porta que a API vai rodar
EXPOSE 3000

# Comando para rodar sua API (ajuste se seu script for diferente)
CMD ["npm", "start"]
