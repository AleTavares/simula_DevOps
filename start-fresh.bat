@echo off
echo === LIMPANDO TUDO ===
docker stop devops-postgres devops-nodejs-app 2>nul
docker rm devops-postgres devops-nodejs-app 2>nul
docker network rm devops-network 2>nul
docker volume rm postgres-data 2>nul

echo === CONSTRUINDO IMAGEM ===
docker build -t devops-nodejs-app .

echo === CRIANDO REDE ===
docker network create devops-network

echo === SUBINDO POSTGRES ===
docker run -d --name devops-postgres --network devops-network -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=admin -e POSTGRES_DB=devops_class -p 5432:5432 postgres:13

echo === AGUARDANDO POSTGRES ===
timeout /t 10

echo === CRIANDO TABELAS ===
docker exec -i devops-postgres psql -U postgres -d devops_class < src\database\schema.sql

echo === SUBINDO APP ===
docker run -d --name devops-nodejs-app --network devops-network -e DB_HOST=devops-postgres -e DB_PORT=5432 -e DB_USER=postgres -e DB_PASSWORD=admin -e DB_NAME=devops_class -p 3000:3000 devops-nodejs-app

echo === AGUARDANDO APP ===
timeout /t 5

echo === TESTANDO ===
curl http://localhost:3000/cursos

echo === PRONTO! ===
echo Acesse: http://localhost:3000