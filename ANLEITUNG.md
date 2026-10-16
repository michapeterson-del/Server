# Eigener Server statt Vercel, Render und Supabase

Am Ende läuft alles auf **einem** Server bei Hetzner, unter **deiner** Domain,
gesteuert über **Coolify**. Kosten: ca. 9 €/Monat.

## Schritt 1 – Hetzner-Konto
1. https://accounts.hetzner.com/signUp → registrieren
2. E-Mail bestätigen, Identitätsprüfung abschließen

## Schritt 2 – SSH-Key erstellen (auf deinem PC)
Das ist dein „Schlüssel“ zum Server – sicherer als ein Passwort.

Windows: PowerShell öffnen, dann:
```powershell
ssh-keygen -t ed25519
```
Einfach 3× Enter drücken. Dann den Schlüssel anzeigen:
```powershell
type $env:USERPROFILE\.ssh\id_ed25519.pub
```
Die ganze Zeile (beginnt mit `ssh-ed25519`) kopieren.

## Schritt 3 – Server erstellen
https://console.hetzner.cloud → Neues Projekt → **Server hinzufügen**
- Standort: **Nürnberg** oder **Falkenstein**
- Image: **Ubuntu 24.04**
- Typ: **Shared vCPU → x86 → CX32** (8 GB RAM)
- Netzwerk: **IPv4 und IPv6** an
- SSH-Key: **hinzufügen** → kopierte Zeile einfügen
- Backups: an (kostet ca. 20 % extra, lohnt sich)
- Name: z. B. `mein-server`

→ Erstellen. Die **IP-Adresse** notieren.

## Schritt 4 – Server einrichten
Auf deinem PC in PowerShell:
```powershell
ssh root@DEINE-IP
```
(Bei der Frage „Are you sure…“ → `yes`)

Dann auf dem Server:
```bash
curl -fsSL https://raw.githubusercontent.com/michapeterson-del/Server/claude/intelligent-sagan-uim2jm/setup.sh | bash
```
Dauert ca. 5 Minuten. Das Skript:
- macht Updates und schaltet automatische Sicherheitsupdates ein
- richtet Firewall und Schutz gegen Login-Angriffe ein
- schaltet Passwort-Login aus (nur noch dein SSH-Key)
- installiert Coolify

## Schritt 5 – Coolify öffnen
Im Browser: `http://DEINE-IP:8000` → **sofort** Admin-Konto anlegen.

## Schritt 6 – Domain
Domain kaufen (z. B. bei Hetzner), dann im DNS eintragen:

| Typ | Name | Wert |
|-----|------|------|
| A   | `@`  | DEINE-IP |
| A   | `*`  | DEINE-IP |

Danach in Coolify unter **Settings** die Domain `https://coolify.deinedomain.de` eintragen.

## Schritt 7 – Umziehen
In Coolify:
- **Projects → New → Public/Private Repository** → deine Apps (statt Vercel/Render)
- **New Resource → Supabase** → deine Datenbank (statt supabase.com)

Erst wenn alles läuft, die alten Dienste abschalten.
