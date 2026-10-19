# Stand – 19.10.2026

## Server
- Hetzner Cloud CAX21 (Falkenstein), Ubuntu 24.04, IP `2.31.44.166`
- Coolify: https://coolify.micha-apps.de (Notzugang: http://2.31.44.166:8000)
- Domain `micha-apps.de` bei Hostinger, DNS: `A @` und `A *` → 2.31.44.166
- Wildcard-Domain in Coolify: https://micha-apps.de
- GitHub App `coolify-micha-apps` (alle Repos) → Auto-Deploy bei jedem Push

## Apps in Coolify
| App | Adresse | Repo / Branch | Daten |
|-----|---------|---------------|-------|
| Gemeinde-Mediathek | gemeinde-mediathek.micha-apps.de | gemeinde / `claude/gemeinde-media-archive-9vqgft` | Volume `/var/data` |
| Picknick-Grill | picknick-grill.micha-apps.de | Picknick-Grill / `claude/icknick-grill-maps-rl9iua` | Volume `/var/data` |
| Pizzeria Mama | pizzeria-mama.micha-apps.de | Pizzeria-Mama | Volume `/var/data` |
| LiveAgent (MCP) | ich-mache-liveagent-kaputt.micha-apps.de/mcp/<secret> | LiveAgent / `claude/security-fixes` | – |
| Umfrage | tepto-umfrage.de (DNS bei IONOS) | Umfrage / `main` | Postgres `umfrage-db` |
| Zahlaufträge | (Coolify-Domain) | Zahlauftr-ge | Postgres `zahlauftraege-db`, Scheduled Task 11/21 Uhr |
| Plaude | plaude.micha-apps.de | Plaude-auf-Temu / `coolify` (serve.js) | Supabase `todo-planner` (extern) |
| Kirche-Bauplan | (statisch) | Kirche-bauplan / `claude/adoring-bohr-4co8en` | – |

## Aufräumen (offen)
- Render: Services löschen, Account löschen
- Vercel: Projekte löschen (Domain `tepto-umfrage.de` vorher bei Vercel entfernen)
- Neon: `neon-emerald-pendant` (Umfrage) und `neon-cinnabar-ball` (Zahlaufträge) löschen
- GitHub: Workflow „Zahlungsauftrag-Erinnerung“ in Zahlauftr-ge deaktivieren
- Optional: Hetzner-Backups (~2,50 €/Monat)
