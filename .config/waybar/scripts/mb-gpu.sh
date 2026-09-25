#!/usr/bin/env bash
# GPU NVIDIA para a waybar. Um único nvidia-smi fica vivo com -l 10
# (amostra a cada 10 s) em vez de criar um processo novo por atualização.
set -uo pipefail
command -v nvidia-smi >/dev/null || { echo '{"text":"","tooltip":"nvidia-smi ausente"}'; exit 0; }
nvidia-smi -l 10 \
  --query-gpu=utilization.gpu,temperature.gpu,memory.used,memory.total,power.draw,clocks.gr,name \
  --format=csv,noheader,nounits |
while IFS=', ' read -r util temp used total power clock name; do
    class=normal
    (( temp >= 80 )) && class=critical || { (( temp >= 70 )) && class=warning; }
    printf '{"text":"%s%%","class":"%s","tooltip":"<b>%s</b>\\nUso %s%%  ·  %s°C\\nVRAM %s / %s MiB\\n%s W  ·  %s MHz"}\n' \
        "$util" "$class" "$name" "$util" "$temp" "$used" "$total" "$power" "$clock"
done
