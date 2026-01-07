#!/bin/bash

# ================================
# Network Health Checker (Cross-Platform)
# Supports: Linux, Git Bash (Windows)
# ================================

GREEN="\e[32m"
YELLOW="\e[33m"
RED="\e[31m"
RESET="\e[0m"

section() {
  echo -e "\n${YELLOW}== $1 ==${RESET}"
}

log_ok()   { echo -e "${GREEN}✔ $1${RESET}"; }
log_fail() { echo -e "${RED}✖ $1${RESET}"; }

OS="$(uname -s)"

section "Operating System"
echo "Detected: $OS"

# -------------------------------
# WINDOWS (Git Bash)
# -------------------------------
if [[ "$OS" == MINGW* || "$OS" == CYGWIN* ]]; then

  section "Network Interfaces"
  ipconfig | grep -E "adapter|IPv4"

  section "Internet Connectivity"
  if ping -n 1 8.8.8.8 >/dev/null 2>&1; then
    log_ok "Internet reachable"
  else
    log_fail "No internet access"
  fi

  section "DNS Resolution"
  if ping -n 1 google.com >/dev/null 2>&1; then
    log_ok "DNS resolution working"
  else
    log_fail "DNS resolution failed"
  fi

  section "HTTP Connectivity"
  if curl -Is https://google.com --max-time 5 >/dev/null 2>&1; then
    log_ok "HTTP/HTTPS access OK"
  else
    log_fail "HTTP/HTTPS failed"
  fi

  section "Public IP"
  curl -s https://ifconfig.me || echo "Unavailable"

  echo -e "\n${GREEN}Network check complete (Windows mode).${RESET}"
  exit 0
fi

# -------------------------------
# LINUX
# -------------------------------
section "Interface Status"
IFACE=$(ip route | awk '/default/ {print $5}' | head -n1)

[[ -n "$IFACE" ]] && log_ok "Active interface: $IFACE" || log_fail "No interface detected"

section "IP Address"
ip addr show "$IFACE" | awk '/inet / {print $2}'

section "Gateway Check"
GATEWAY=$(ip route | awk '/default/ {print $3}')

ping -c 1 -W 2 "$GATEWAY" >/dev/null && log_ok "Gateway reachable" || log_fail "Gateway unreachable"

section "DNS Resolution"
getent hosts google.com >/dev/null && log_ok "DNS working" || log_fail "DNS failed"

section "Internet Connectivity"
ping -c 1 -W 2 8.8.8.8 >/dev/null && log_ok "Internet reachable" || log_fail "No internet"

section "HTTP Connectivity"
curl -Is https://google.com --max-time 5 >/dev/null && log_ok "HTTP OK" || log_fail "HTTP failed"

section "Public IP"
curl -s https://ifconfig.me || echo "Unavailable"

echo -e "\n${GREEN}Network check complete (Linux mode).${RESET}"

