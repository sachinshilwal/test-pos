#!/bin/bash
# OSPOS Development Environment Helper Script

set -e

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$PROJECT_DIR"

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Get user/group IDs
export USERID=$(id -u)
export GROUPID=$(id -g)

show_help() {
    echo -e "${BLUE}OSPOS Development Helper${NC}"
    echo ""
    echo "Usage: ./dev.sh [command]"
    echo ""
    echo "Commands:"
    echo "  start     - Start the development environment (Docker + Gulp watch)"
    echo "  stop      - Stop the development environment"
    echo "  restart   - Restart the development environment"
    echo "  logs      - Show application logs"
    echo "  build     - Build CSS/JS resources"
    echo "  db        - Access MySQL database shell"
    echo "  status    - Show container status"
    echo "  help      - Show this help message"
    echo ""
}

start_dev() {
    echo -e "${GREEN}🚀 Starting OSPOS Development Environment...${NC}"
    
    # Check if container needs rebuilding
    if ! docker images | grep -q "opensourcepos-ospos"; then
        echo -e "${BLUE}Building Docker image for the first time...${NC}"
        USERID=$USERID GROUPID=$GROUPID docker compose -f docker-compose.dev.yml up -d --build
    else
        # Start Docker containers
        echo -e "${BLUE}Starting Docker containers...${NC}"
        USERID=$USERID GROUPID=$GROUPID docker compose -f docker-compose.dev.yml up -d
    fi
    
    # Wait for MySQL to be ready
    echo -e "${BLUE}Waiting for MySQL to be ready...${NC}"
    sleep 5
    
    # Build resources if needed
    if [ ! -d "public/resources" ]; then
        echo -e "${BLUE}Building initial resources...${NC}"
        npm run gulp debug-js
        npm run gulp debug-css
    fi
    
    echo ""
    echo -e "${GREEN}✅ Development environment is ready!${NC}"
    echo -e "${YELLOW}📱 Access the application at: http://localhost${NC}"
    echo -e "${YELLOW}👤 Login: admin / pointofsale${NC}"
    echo ""
    echo -e "${BLUE}💡 To start watching for CSS changes, run:${NC}"
    echo -e "   ${GREEN}npm run gulp watch${NC}"
    echo ""
    echo -e "${BLUE}💡 CSS files are in:${NC} ${GREEN}public/css/${NC}"
    echo -e "${BLUE}   Edit any CSS file and changes will reflect immediately in browser!${NC}"
    echo ""
}

stop_dev() {
    echo -e "${YELLOW}🛑 Stopping OSPOS Development Environment...${NC}"
    docker compose -f docker-compose.dev.yml down
    echo -e "${GREEN}✅ Stopped${NC}"
}

restart_dev() {
    stop_dev
    start_dev
}

show_logs() {
    docker logs -f ospos_dev
}

build_resources() {
    echo -e "${BLUE}Building CSS and JS resources...${NC}"
    npm run gulp debug-js
    npm run gulp debug-css
    echo -e "${GREEN}✅ Build complete${NC}"
}

db_shell() {
    echo -e "${BLUE}Connecting to MySQL database...${NC}"
    docker exec -it mysql mysql -uadmin -ppointofsale ospos
}

show_status() {
    echo -e "${BLUE}Container Status:${NC}"
    docker compose -f docker-compose.dev.yml ps
}

# Main command handling
case "${1:-}" in
    start)
        start_dev
        ;;
    stop)
        stop_dev
        ;;
    restart)
        restart_dev
        ;;
    logs)
        show_logs
        ;;
    build)
        build_resources
        ;;
    db)
        db_shell
        ;;
    status)
        show_status
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        if [ -z "${1:-}" ]; then
            start_dev
        else
            echo -e "${RED}Unknown command: $1${NC}"
            echo ""
            show_help
            exit 1
        fi
        ;;
esac
