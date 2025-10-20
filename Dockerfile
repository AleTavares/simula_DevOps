# Use a imagem oficial do Node.js 18 baseada no Alpine Linux
FROM node:18-alpine

# Define o diretório de trabalho dentro do container
WORKDIR /app

# Copia o package.json e package-lock.json (se existir)
COPY package*.json ./

# Instala as dependências
RUN npm ci --only=production

# Copia o código da aplicação
COPY src/ ./src/

# Expõe a porta 3000
EXPOSE 3000

# Define as variáveis de ambiente padrão
ENV NODE_ENV=production
ENV PORT=3000

# Cria um usuário não-root para executar a aplicação
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nextjs -u 1001

# Muda a propriedade dos arquivos para o usuário nodejs
RUN chown -R nextjs:nodejs /app
USER nextjs

# Comando para iniciar a aplicação
CMD ["npm", "start"]