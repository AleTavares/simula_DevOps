# Imagem base do Node.js
FROM node:18-alpine

# Definir o diretório de trabalho dentro do container
WORKDIR /app

# Copiar os arquivos de dependências
COPY package*.json ./

# Instalar as dependências
RUN npm install --production

# Copiar todo o código da aplicação
COPY . .

# Expor a porta da aplicação
EXPOSE 3000

# Variáveis de ambiente padrão (podem ser sobrescritas)
ENV PORT=3000
ENV DB_USER=postgres
ENV DB_HOST=postgres
ENV DB_NAME=devops_class
ENV DB_PASSWORD=admin
ENV DB_PORT=5432

# Comando para iniciar a aplicação
CMD ["npm", "start"]
