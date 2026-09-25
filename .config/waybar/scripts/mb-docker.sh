#!/usr/bin/env bash
# Containers Docker em execução. Esconde o módulo quando não há nenhum
# ou quando o daemon está fora. Chamado pela waybar a cada 30 s.
names=$(timeout 3 docker ps --format '{{.Names}}' 2>/dev/null) || { echo '{"text":""}'; exit 0; }
[[ -z $names ]] && { echo '{"text":""}'; exit 0; }
count=$(wc -l <<<"$names")
tip=$(sed 's/$/\\n/' <<<"$names" | tr -d '\n' | sed 's/\\n$//')
printf '{"text":"%s","tooltip":"<b>%s containers</b>\\n%s"}\n' "$count" "$count" "$tip"
