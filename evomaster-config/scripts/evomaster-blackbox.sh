#!/bin/bash

# =============================================================================
# EvoMaster Black-Box Test Generator
# =============================================================================
# Gera testes automatizados para APIs REST usando EvoMaster em modo black-box
#
# Uso:
#   ./evomaster-blackbox.sh <serviço> [role]
#
# Exemplos:
#   ./evomaster-blackbox.sh ts-auth-service
#   ./evomaster-blackbox.sh ts-auth-service admin
#   ./evomaster-blackbox.sh ts-auth-service user
#   ./evomaster-blackbox.sh ts-auth-service none
# =============================================================================

set -e

# -----------------------------------------------------------------------------
# Configurações
# -----------------------------------------------------------------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUTPUT_BASE_DIR="$SCRIPT_DIR/../../generated-tests/blackbox"
SWAGGER_DIR="$SCRIPT_DIR/../blackbox/swagger-specs"

# Parâmetros do EvoMaster
MAX_TIME="${EVOMASTER_MAX_TIME:-60}"      # 1 minutos padrão
RATE_PER_MINUTE="${EVOMASTER_RATE:-60}"

# Argumentos
SERVICE_NAME="${1:-}"
USER_ROLE="${2:-user}"  # admin ou user

# Credenciais
ADMIN_USERNAME="admin"
ADMIN_PASSWORD="222222"
USER_USERNAME="fdse_microservice"
USER_PASSWORD="111111"

# URLs
GATEWAY_URL="http://localhost:8888"
AUTH_URL="http://localhost:8890"

# Cores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

# -----------------------------------------------------------------------------
# Funções
# -----------------------------------------------------------------------------

show_usage() {
    echo -e "${BLUE}Uso:${NC}"
    echo -e "  $0 <serviço> [role]"
    echo -e ""
    echo -e "${BLUE}Argumentos:${NC}"
    echo -e "  serviço    Nome do serviço (ex: ts-auth-service)"
    echo -e "  role       Role do usuário: admin, user ou none (padrão: user)"
    echo -e "             - admin: autenticado como administrador"
    echo -e "             - user:  autenticado como usuário comum"
    echo -e "             - none:  sem autenticação"
    echo -e ""
    echo -e "${BLUE}Exemplos:${NC}"
    echo -e "  $0 ts-auth-service"
    echo -e "  $0 ts-auth-service admin"
    echo -e "  $0 ts-contacts-service user"
    echo -e "  $0 ts-contacts-service none"
    echo -e ""
    echo -e "${BLUE}Variáveis de ambiente:${NC}"
    echo -e "  EVOMASTER_MAX_TIME   Tempo máximo em segundos (padrão: 300)"
    echo -e "  EVOMASTER_RATE       Requisições por minuto (padrão: 60)"
}

get_token() {
    local username="$1"
    local password="$2"
    
    # Tentar via gateway primeiro, depois direto no auth-service
    local urls=("$GATEWAY_URL/api/v1/users/login" "$AUTH_URL/api/v1/users/login")
    
    for url in "${urls[@]}"; do
        local response=$(curl -s -X POST "$url" \
            -H "Content-Type: application/json" \
            -d "{\"username\":\"$username\",\"password\":\"$password\"}" 2>/dev/null)
        
        local token=$(echo "$response" | grep -o '"token":"[^"]*"' | cut -d'"' -f4)
        
        if [ -n "$token" ]; then
            echo "$token"
            return 0
        fi
    done
    
    return 1
}

# -----------------------------------------------------------------------------
# Validações
# -----------------------------------------------------------------------------

if [ -z "$SERVICE_NAME" ]; then
    echo -e "${RED}Erro: Nome do serviço é obrigatório${NC}\n"
    show_usage
    exit 1
fi

if [ "$USER_ROLE" != "admin" ] && [ "$USER_ROLE" != "user" ] && [ "$USER_ROLE" != "none" ]; then
    echo -e "${YELLOW}Aviso: Role '$USER_ROLE' inválida. Usando 'user'.${NC}"
    USER_ROLE="user"
fi

# Verificar Docker
if ! command -v docker &> /dev/null; then
    echo -e "${RED}Erro: Docker não está instalado${NC}"
    exit 1
fi

# -----------------------------------------------------------------------------
# Preparação
# -----------------------------------------------------------------------------

echo -e "${BLUE}=== EvoMaster Black-Box ===${NC}\n"

echo -e "${YELLOW}Serviço:${NC} $SERVICE_NAME"
echo -e "${YELLOW}Role:${NC} $USER_ROLE"
echo -e "${YELLOW}Tempo máximo:${NC} ${MAX_TIME}s"
echo -e "${YELLOW}Taxa:${NC} ${RATE_PER_MINUTE} req/min"
echo ""

# Criar diretórios (estrutura: service-name/role/)
OUTPUT_DIR="$OUTPUT_BASE_DIR/$SERVICE_NAME/$USER_ROLE"
mkdir -p "$OUTPUT_DIR"
mkdir -p "$SWAGGER_DIR"

echo -e "${YELLOW}Diretório de saída:${NC} $OUTPUT_DIR"

# -----------------------------------------------------------------------------
# Obter Token de Autenticação
# -----------------------------------------------------------------------------

AUTH_HEADER=""

if [ "$USER_ROLE" = "none" ]; then
    echo -e "${YELLOW}Modo sem autenticação (none)${NC}"
else
    echo -e "${YELLOW}Obtendo token de autenticação...${NC}"
    
    if [ "$USER_ROLE" = "admin" ]; then
        TOKEN=$(get_token "$ADMIN_USERNAME" "$ADMIN_PASSWORD" || echo "")
    else
        TOKEN=$(get_token "$USER_USERNAME" "$USER_PASSWORD" || echo "")
    fi
    
    if [ -n "$TOKEN" ]; then
        echo -e "${GREEN}✓ Token obtido${NC}"
        AUTH_HEADER="Authorization:Bearer $TOKEN"
    else
        echo -e "${YELLOW}⚠ Não foi possível obter token.${NC}"
        echo -e "${YELLOW}  Dica: Limpe o volume MySQL para recriar usuários:${NC}"
        echo -e "${YELLOW}    docker compose down && docker volume rm train-ticket-aitest_mysql_data && docker compose up -d${NC}"
        echo -e "${YELLOW}  Continuando sem autenticação...${NC}"
    fi
fi

# -----------------------------------------------------------------------------
# Determinar URL do Swagger
# -----------------------------------------------------------------------------

echo -e "\n${YELLOW}Verificando especificação Swagger...${NC}"

SWAGGER_URL=""

# 1. Verificar arquivo local
SPEC_FILE="$SWAGGER_DIR/${SERVICE_NAME}-openapi.json"
if [ -f "$SPEC_FILE" ]; then
    SWAGGER_URL="file:///swagger/${SERVICE_NAME}-openapi.json"
    echo -e "${GREEN}✓ Usando arquivo local: $(basename "$SPEC_FILE")${NC}"
else
    # 2. Tentar gateway
    GATEWAY_SWAGGER="$GATEWAY_URL/v2/api-docs"
    if curl -s -f "$GATEWAY_SWAGGER" &> /dev/null; then
        SWAGGER_URL="$GATEWAY_SWAGGER"
        echo -e "${GREEN}✓ Usando Swagger do gateway${NC}"
    else
        echo -e "${RED}✗ Nenhuma especificação Swagger encontrada${NC}"
        echo -e "${YELLOW}Verifique se o serviço está rodando ou se há um arquivo em:${NC}"
        echo -e "  $SWAGGER_DIR/${SERVICE_NAME}-openapi.json"
        exit 1
    fi
fi

# -----------------------------------------------------------------------------
# Executar EvoMaster
# -----------------------------------------------------------------------------

echo -e "\n${GREEN}Executando EvoMaster...${NC}"
echo -e "${YELLOW}Swagger URL:${NC} $SWAGGER_URL"
echo ""

# Montar comando Docker
DOCKER_ARGS=(
    "run" "--rm"
    "-v" "$OUTPUT_DIR:/output"
    "-v" "$SWAGGER_DIR:/swagger"
    "--network" "host"
    "webfuzzing/evomaster"
    "--blackBox" "true"
    "--bbSwaggerUrl" "$SWAGGER_URL"
    "--maxTime" "${MAX_TIME}s"
    "--ratePerMinute" "$RATE_PER_MINUTE"
    "--outputFormat" "JAVA_JUNIT_5"
    "--outputFolder" "/output"
    "--testSuiteFileName" "EvoMaster_Test"
)

# Adicionar header de autenticação se disponível (EvoMaster 4.0 usa --header0)
if [ -n "$AUTH_HEADER" ]; then
    DOCKER_ARGS+=("--header0" "$AUTH_HEADER")
    echo -e "${BLUE}Header de autenticação configurado${NC}"
fi

# Executar
docker "${DOCKER_ARGS[@]}"

EXIT_CODE=$?

# -----------------------------------------------------------------------------
# Resultado
# -----------------------------------------------------------------------------

echo ""
if [ $EXIT_CODE -eq 0 ]; then
    echo -e "${GREEN}✓ Testes gerados com sucesso!${NC}"
    echo -e "${YELLOW}Localização:${NC} $OUTPUT_DIR"
    echo ""
    echo -e "${BLUE}Arquivos gerados:${NC}"
    find "$OUTPUT_DIR" -name "*.java" -newer "$OUTPUT_DIR" -mmin -5 2>/dev/null | while read -r f; do
        echo -e "  - $(basename "$f")"
    done
else
    echo -e "${RED}✗ Erro ao executar EvoMaster (código: $EXIT_CODE)${NC}"
    exit $EXIT_CODE
fi

