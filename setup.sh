#!/usr/bin/env bash
# Einrichtungs-Skript für einen frischen Ubuntu-24.04-Server (z. B. Hetzner Cloud).
# Sichert den Server ab und installiert Coolify.
#
# Ausführen als root:
#   curl -fsSL https://raw.githubusercontent.com/michapeterson-del/Server/claude/intelligent-sagan-uim2jm/setup.sh | bash
set -euo pipefail

log() { echo -e "\n\033[1;32m==> $*\033[0m"; }
warn() { echo -e "\033[1;33m[!] $*\033[0m"; }

if [[ $EUID -ne 0 ]]; then
  echo "Bitte als root ausführen." >&2
  exit 1
fi

export DEBIAN_FRONTEND=noninteractive

log "System aktualisieren"
apt-get update -y
apt-get upgrade -y

log "Basis-Pakete installieren (Firewall, Fail2ban, automatische Updates)"
apt-get install -y curl ca-certificates ufw fail2ban unattended-upgrades

log "Automatische Sicherheitsupdates einschalten"
cat > /etc/apt/apt.conf.d/20auto-upgrades <<'CONF'
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Unattended-Upgrade "1";
CONF

log "Fail2ban aktivieren (sperrt IPs nach falschen SSH-Logins)"
systemctl enable --now fail2ban

log "Swap anlegen (falls noch keiner da ist)"
if ! swapon --show | grep -q .; then
  fallocate -l 2G /swapfile
  chmod 600 /swapfile
  mkswap /swapfile
  swapon /swapfile
  echo '/swapfile none swap sw 0 0' >> /etc/fstab
else
  echo "Swap ist schon vorhanden."
fi

log "Firewall einrichten"
ufw default deny incoming
ufw default allow outgoing
ufw allow 22/tcp    # SSH
ufw allow 80/tcp    # HTTP
ufw allow 443/tcp   # HTTPS
ufw allow 8000/tcp  # Coolify-Oberfläche (bis eine Domain eingerichtet ist)
ufw allow 6001/tcp  # Coolify Realtime
ufw allow 6002/tcp  # Coolify Terminal
ufw --force enable

log "SSH absichern"
if [[ -s /root/.ssh/authorized_keys ]]; then
  # 00- damit diese Datei vor 50-cloud-init.conf gelesen wird (erster Wert gewinnt)
  cat > /etc/ssh/sshd_config.d/00-hardening.conf <<'CONF'
PasswordAuthentication no
KbdInteractiveAuthentication no
PermitRootLogin prohibit-password
CONF
  sshd -t
  systemctl restart ssh
  echo "Login per Passwort ist jetzt aus, nur noch per SSH-Key."
else
  warn "Kein SSH-Key gefunden – Passwort-Login bleibt an. Bitte SSH-Key hinterlegen!"
fi

log "Coolify installieren"
curl -fsSL https://cdn.coollabs.io/coolify/install.sh | bash

IP=$(curl -fsS4 https://ifconfig.me || hostname -I | awk '{print $1}')
log "Fertig!"
echo "Öffne jetzt im Browser:  http://${IP}:8000"
echo "und lege dort sofort dein Admin-Konto an."
