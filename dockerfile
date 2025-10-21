# Escolhe uma imagem base Node.js
FROM node:18

# Diretório de trabalho dentro do container
WORKDIR /app

# Copia package.json e package-lock.json
COPY package*.json ./

# Instala dependências
RUN npm install

# Copia todo o restante do código
COPY . .

# Expõe a porta que a API vai rodar
EXPOSE 3000

# Comando para rodar a aplicação
CMD ["npm", "start"]
