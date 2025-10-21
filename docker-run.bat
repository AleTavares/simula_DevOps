@echo off
echo ========================================
echo  DevOps Exercise - Docker Management
echo ========================================

if "%1"=="up" (
    echo Iniciando aplicacao...
    docker-compose up -d --build
    echo.
    echo Aplicacao disponivel em: http://localhost:3000
    echo Banco PostgreSQL disponivel em: localhost:5432
    goto end
)

if "%1"=="down" (
    echo Parando aplicacao...
    docker-compose down
    goto end
)

if "%1"=="logs" (
    echo Mostrando logs...
    docker-compose logs -f
    goto end
)

if "%1"=="restart" (
    echo Reiniciando aplicacao...
    docker-compose restart
    goto end
)

if "%1"=="clean" (
    echo Limpando containers e volumes...
    docker-compose down -v
    docker system prune -f
    goto end
)

echo Uso: docker-run.bat [comando]
echo.
echo Comandos disponiveis:
echo   up      - Inicia a aplicacao
echo   down    - Para a aplicacao
echo   logs    - Mostra os logs
echo   restart - Reinicia a aplicacao
echo   clean   - Limpa containers e volumes

:end