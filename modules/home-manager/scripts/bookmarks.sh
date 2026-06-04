#!/usr/bin/env bash
set -euo pipefail

# List of bookmarks (Format: Name | URL)
bookmarks_data=$(cat <<EOF
Gmail | https://mail.google.com
Google Calendar | https://calendar.google.com
Bastter System | https://bastter.com/bs2
FMHY Audio Ripping | https://fmhy.net/audio#audio-ripping
Sonarr | http://sonarr.local.cbmgo.org
Radarr | http://radarr.local.cbmgo.org
Lidarr | http://lidarr.local.cbmgo.org
Bazarr | http://bazarr.local.cbmgo.org
qBittorrent | http://qbittorrent.local.cbmgo.org
CBMGO Contatos e Endereços | https://www.bombeiros.go.gov.br/acesso-a-informacao/contatos-enderecos-horarios-cargos-e-ocupantes
CBMGO Normas Administrativas | https://www.bombeiros.go.gov.br/legislacao/normas-administrativas-2.html
CBMGO Normas Operacionais | https://www.bombeiros.go.gov.br/legislacao/normas-operacionais-administrativas/normas-operacionais-2.html
CBMGO Manuais | https://www.bombeiros.go.gov.br/legislacao/manuais-de-bombeiros/manuais-de-bombeiros.html
EOF
)

# Show menu
selected=$(echo "$bookmarks_data" | vicinae dmenu --placeholder "Go to ")

if [ -n "$selected" ]; then
    url="${selected##* | }"
    xdg-open "$url"
fi
