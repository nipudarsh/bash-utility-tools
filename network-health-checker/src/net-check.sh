#!/bin/bash

# ================================
# Network Health Checker
# ================================

GREEN="\e[32m"
YELLOW="\e[33m"
RED="\e[31m"
RESET="\e[0m"

log() {
  echo -e "$1"
}

section() {
  echo -e "\n${YELLOW}== $1 ==${RESET}"
}

check_cmd() {
  command -v "$1" &>/dev/null || {
    echo -e "${RED}Missing required command: $1${RESET}"
    exit 1
  }
}

# Required tools
for cmd in ip ping curl awk; do
  check_cmd "$cmd"
done

section "Interface Status"
IFACE=$(ip route | awk '/default/ {print $5}' | head -n1)

if [[ -n "$IFACE" ]]; then
  log "${GREEN}Active Interface:${RESET} $IFACE"
else
  log "${RED}No active network interface detected${RESET}"
fi

section "IP Address"
ip addr show "$IFACE" | awk '/inet / {print "IP Address:", $2}'

section "Gateway Check"
GATEWAY=$(ip route | awk '/default/ {print $3}')

if ping -c 1 -W 2 "$GATEWAY" &>/dev/null; then
  log "${GREEN}Gateway reachable${RESET}"
else
  log "${RED}Gateway unreachable${RESET}"
fi

section "DNS Resolution"
if getent hosts google.com &>/dev/null; then
  log "${GREEN}DNS resolution working${RESET}"
else
  log "${RED}DNS resolution failed${RESET}"
fi

section "Internet Connectivity"
if ping -c 1 -W 2 8.8.8.8 &>/dev/null; then
  log "${GREEN}Internet reachable${RESET}"
else
  log "${RED}No internet access${RESET}"
fi

section "HTTP Connectivity"
if curl -Is https://google.com --max-time 5 &>/dev/null; then
  log "${GREEN}HTTP/HTTPS access OK${RESET}"
else
  log "${RED}HTTP/HTTPS failed${RESET}"
fi

section "Public IP"
curl -s https://ifconfig.me || echo "Unavailable"

echo -e "\n${GREEN}Network check complete.${RESET}"
