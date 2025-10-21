# Usa imagem oficial do Node.js
FROM node:18-alpine

# Define o diretório de trabalho dentro do container
WORKDIR /app

# Copia os arquivos de dependências
COPY package*.json ./

# Instala apenas as dependências de produção
RUN npm install --production

# Copia todo o restante do código para dentro do container
COPY . .

# Expõe a porta da aplicação (a mesma que você usa no Node)
EXPOSE 3000

# Comando para iniciar a API
CMD ["npm", "start"]
