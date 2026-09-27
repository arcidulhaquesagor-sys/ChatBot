#!/usr/bin/env bash
# ================================================================
# setup.sh — ChatBot project setup script
# Usage: bash setup.sh
# ================================================================

set -e   # exit on first error

# ── Colours ──────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

info()    { echo -e "${CYAN}[INFO]${RESET}  $*"; }
success() { echo -e "${GREEN}[OK]${RESET}    $*"; }
warn()    { echo -e "${YELLOW}[WARN]${RESET}  $*"; }
error()   { echo -e "${RED}[ERROR]${RESET} $*"; exit 1; }

echo ""
echo -e "${BOLD}╔══════════════════════════════════════════╗${RESET}"
echo -e "${BOLD}║       AI Chatbot — Project Setup         ║${RESET}"
echo -e "${BOLD}╚══════════════════════════════════════════╝${RESET}"
echo ""

# ── Step 0: Check prerequisites ──────────────────────────────────
info "Checking prerequisites..."

if ! command -v git &>/dev/null; then
    error "git not found. Install Xcode Command Line Tools first:\n  xcode-select --install\nThen re-run this script."
fi
success "git found: $(git --version)"

if ! command -v python3 &>/dev/null; then
    error "python3 not found. Install Python 3.10+ from https://python.org"
fi
success "python3 found: $(python3 --version)"

# ── Step 1: Create .env if missing ───────────────────────────────
echo ""
info "Checking .env file..."
if [ ! -f ".env" ]; then
    warn ".env not found — creating template."
    cat > .env <<'EOF'
# Paste your Gemini API key below (get one at https://aistudio.google.com/app/apikey)
GEMINI_API_KEY=your_gemini_api_key_here
EOF
    echo -e "${YELLOW}  ➜  Open .env and replace 'your_gemini_api_key_here' with your real key.${RESET}"
else
    success ".env already exists."
fi

# ── Step 2: Virtual environment ───────────────────────────────────
echo ""
info "Setting up Python virtual environment..."
if [ ! -d "venv" ]; then
    python3 -m venv venv
    success "Virtual environment created at ./venv"
else
    success "Virtual environment already exists."
fi

# Activate
# shellcheck disable=SC1091
source venv/bin/activate
success "Virtual environment activated."

# ── Step 3: Install dependencies ──────────────────────────────────
echo ""
info "Installing Python dependencies from requirements.txt..."
pip install --quiet --upgrade pip
pip install --quiet -r requirements.txt
success "Dependencies installed."

# ── Step 4: Validate API key in .env ─────────────────────────────
echo ""
info "Validating GEMINI_API_KEY..."
API_KEY_VALUE=$(grep -E '^GEMINI_API_KEY=' .env 2>/dev/null | cut -d'=' -f2- | tr -d '"' | tr -d "'")
if [ -z "$API_KEY_VALUE" ] || [ "$API_KEY_VALUE" = "your_gemini_api_key_here" ]; then
    warn "GEMINI_API_KEY is not set in .env."
    warn "The server will start but AI responses will fail until the key is added."
else
    success "GEMINI_API_KEY is set (${#API_KEY_VALUE} chars)."
fi

# ── Step 5: Git repository ────────────────────────────────────────
echo ""
info "Initialising Git repository..."
if [ ! -d ".git" ]; then
    git init
    success "Git repository initialised."
else
    success "Git repository already initialised."
fi

# Configure a local identity if none is set globally
if ! git config user.email &>/dev/null; then
    git config user.email "you@example.com"
    git config user.name  "Developer"
    warn "No global git identity found — set a temporary local one."
    warn "Update later with: git config --global user.email 'you@real.com'"
fi

# Stage and commit
info "Staging files..."
git add .

# Check if there's anything to commit
if git diff --cached --quiet; then
    success "Nothing new to commit — working tree is clean."
else
    git commit -m "feat: initial AI chatbot setup"
    success "Committed: 'feat: initial AI chatbot setup'"
fi

# ── Step 6: Start local server ────────────────────────────────────
echo ""
echo -e "${BOLD}╔══════════════════════════════════════════╗${RESET}"
echo -e "${BOLD}║         Starting Local Dev Server        ║${RESET}"
echo -e "${BOLD}╚══════════════════════════════════════════╝${RESET}"
echo ""
echo -e "  ${GREEN}➜  Server:${RESET}  http://127.0.0.1:8000"
echo -e "  ${GREEN}➜  API:${RESET}     http://127.0.0.1:8000/api/chat"
echo -e "  ${GREEN}➜  Docs:${RESET}    http://127.0.0.1:8000/docs"
echo -e "  ${YELLOW}Press Ctrl+C to stop the server.${RESET}"
echo ""

uvicorn main:app --reload --host 0.0.0.0 --port 8000
