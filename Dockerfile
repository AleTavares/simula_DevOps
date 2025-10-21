# Imagem base NodeJS 18
FROM node:18

# Diretório de trabalho
WORKDIR /app

# Copia package.json e package-lock.json
COPY package*.json ./

# Instala dependências
RUN npm install

# Copia todo o código da aplicação
COPY . .

# Porta que a API vai usar
EXPOSE 3000

# Comando para rodar a API
CMD ["npm", "start"]


