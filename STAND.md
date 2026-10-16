# Stand – 16.10.2026

## Server
- Hetzner Cloud CAX21 (Falkenstein), Ubuntu 24.04, IP `2.31.44.166`
- Coolify: https://coolify.micha-apps.de (Notzugang: http://2.31.44.166:8000)
- Domain `micha-apps.de` bei Hostinger, DNS: `A @` und `A *` → 2.31.44.166
- Wildcard-Domain in Coolify: https://micha-apps.de

## Umgezogen (laufen in Coolify)
| App | Adresse | Repo / Branch |
|-----|---------|---------------|
| Gemeinde-Mediathek | https://gemeinde-mediathek.micha-apps.de | gemeinde / `claude/gemeinde-media-archive-9vqgft` (GitHub-Webhook aktiv) |
| Picknick-Grill | https://picknick-grill.micha-apps.de | Picknick-Grill / `claude/icknick-grill-maps-rl9iua` |
| Pizzeria Mama | https://pizzeria-mama.micha-apps.de | Pizzeria-Mama |
| LiveAgent (MCP) | https://ich-mache-liveagent-kaputt.micha-apps.de/mcp/<secret> | LiveAgent (privat, Deploy Key) / `claude/security-fixes` |

Mediathek-Daten von Render: Backup auf dem Server unter `/root/render-backup.tar.gz`.

## Offen
- Render: Services löschen, dann Account löschen
- Vercel (3 Projekte): `zahlauftr-ge` (Next.js, privat), `plaude-auf-temu` (statisch + /api), `umfrage` (Next.js)
  → entscheiden: umziehen oder löschen
- Supabase: prüfen, ob noch etwas gebraucht wird
- Optional: Hetzner-Backups (~2,50 €/Monat), Webhooks für die anderen Apps
