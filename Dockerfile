# Dockerfile
FROM node:18-alpine


WORKDIR /app


# copiar package.json e package-lock.json para cache de dependências
COPY package*.json ./


RUN npm ci --production


COPY . .


# se houver build, rodar aqui (ex: transpiler)
# RUN npm run build


ENV PORT=3000
EXPOSE 3000


CMD ["npm", "start"]