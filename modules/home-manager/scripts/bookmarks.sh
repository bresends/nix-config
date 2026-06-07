#!/usr/bin/env bash
set -euo pipefail

# List of bookmarks (Format: Name | URL)
bookmarks_data=$(cat <<EOF
ChatGPT | https://chatgpt.com
Gmail | https://mail.google.com
Google Calendar | https://calendar.google.com
Github | https://github.com/bresends?tab=repositories
Rai - Escala | https://escala.ssp.go.gov.br
Bastter System | https://bastter.com/bs2
FMHY Audio Ripping | https://fmhy.net/audio#audio-ripping
Sonarr | http://sonarr.home.cbmgo.org
Radarr | http://radarr.home.cbmgo.org
Lidarr | http://lidarr.home.cbmgo.org
Bazarr | http://bazarr.home.cbmgo.org
qBittorrent | http://qbittorrent.home.cbmgo.org
CBMGO Contatos e Endereços | https://www.bombeiros.go.gov.br/acesso-a-informacao/contatos-enderecos-horarios-cargos-e-ocupantes
CBMGO Normas Administrativas | https://www.bombeiros.go.gov.br/legislacao/normas-administrativas-2.html
CBMGO Normas Operacionais | https://www.bombeiros.go.gov.br/legislacao/normas-operacionais-administrativas/normas-operacionais-2.html
CBMGO Manuais | https://www.bombeiros.go.gov.br/legislacao/manuais-de-bombeiros/manuais-de-bombeiros.html
SEI - Escala | https://sei.go.gov.br/sei/controlador.php?acao=procedimento_trabalhar&id_procedimento=88711998
SEI - Livro | https://sei.go.gov.br/sei/controlador.php?acao=procedimento_trabalhar&id_procedimento=88653034
EOF
)

# Show menu (display names only)
names=$(echo "$bookmarks_data" | cut -d'|' -f1 | sed 's/[[:space:]]*$//')
selected=$(echo "$names" | vicinae dmenu --placeholder "Go to ")

if [ -n "$selected" ]; then
    # Resolve URL from selected name
    url=$(echo "$bookmarks_data" | grep -F "${selected} |" | cut -d'|' -f2- | sed 's/^[[:space:]]*//')
    if [ -n "$url" ]; then
        xdg-open "$url"
    fi
fi
