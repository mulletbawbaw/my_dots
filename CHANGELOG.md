# Changelog

## 2026-09-25 (tarde)

### Corrigido
- **Flash roxo a cada Tab**: o zsh emitia bell em completions ambíguas e o kitty o
  desenhava como flash roxo da janela. Agora `nobeep`/`nolistbeep` no zsh e
  `visual_bell_duration 0` no kitty. O rastro do cursor segue a cor do cursor (verde).
- Primeiro prompt aparecia com `󰚌 1` (código de saída herdado do `.zshrc`).
- Erro "rice.conf inaccessible" era transitório (troca de branch durante o auto-reload do Hyprland).

### Novo
- `~/.config/zsh/mulletbawbaw/core.zsh`: histórico 100k compartilhado sem duplicatas,
  menu de completion com grupos roxos e seleção verde neon, Shift+Tab, Ctrl+Espaço aceita
  sugestão, Ctrl+Backspace/Delete por palavra, Ctrl+X Ctrl+E edita no nvim, fzf e lsd na
  paleta, `mkcd`, PATH sem duplicatas, suporte a `~/.zshrc.local`.
- `.zshrc` reorganizado (PATH → Oh My Zsh → núcleo → prompt).

## rice/mulletbawbaw-v1 — 2026-09-25

### Novo
- **Design system** central: `theme/palette.json` + `theme/generate.py` (Python puro) gerando
  cores para Hyprland, Waybar, SwayNC, Rofi, Kitty, Neovim, Zsh, KDE, qt6ct e GTK.
- **Wallpapers gerados** a partir da paleta (par por monitor) + `rice-wall`.
- **Fastfetch "PLAYER STATUS"** com o MulletBawbaw via protocolo gráfico do kitty.
- **Prompt zsh próprio** (vcs_info nativo; hora, cwd, branch, dirty/untracked, exit code).
- **Hyprland**: animações 80–200 ms, borda gradiente roxo→verde, glow, blur leve, submap de resize.
- **Waybar** P1/P2 com workspaces que mostram os apps presentes, GPU/temperatura em drawer,
  Docker, microfone, indicador de modo jogo.
- **Rofi** "SELECT", **SwayNC** "INBOX" com controles rápidos, **wlogout** "CONTINUE?",
  **hyprlock** "GAME PAUSED".
- **Neovim**: colorscheme `mulletbawbaw`, dashboard com pixel art, lualine própria,
  LSP para Python/TS/Go/Docker/YAML/JSON/TOML.
- **KDE**: esquema `MulletBawbaw.colors` + `rice-kde` (aplicar/desfazer dentro do Plasma).
- **Qt/GTK no Hyprland**: Breeze + cores do rice (antes: Catppuccin/Kvantum, Flat-Remix, Tokyonight inexistente).
- **`rice-gaming`**: modo jogo real (desliga efeitos em runtime e restaura via `hyprctl reload`).
- Docs em `docs/`, `.zshrc` agora versionado.

### Corrigido (achados da auditoria)
- `SUPER+SHIFT+setas` executava redimensionar **e** mover de monitor ao mesmo tempo.
- `SUPER+W` registrado duas vezes (abria o seletor duas vezes).
- `exec-once = ags` e `SUPER+A` chamavam `ags`, que não existe → overview do Quickshell.
- `swww-daemon` iniciado em duplicidade com `awww-daemon`.
- Dois `cava` permanentes na barra (com `sed` por linha) → removidos.
- Cliques da barra para comandos ausentes (`powerprofilesctl`, `rofi-network-manager`, `mode`, `eww`).
- Módulo de bateria sem bateria.
- Terminal do Rofi era `ghostty`; agora `kitty`.
- Spotify na blacklist do MPRIS do SwayNC; controle de brilho sem hardware.
- wlogout "Suspender" chamava `suspend-then-hibernate` sem hibernação configurada.
- hyprlock apontava para `gruvbox_girl.png` inexistente.
- Regras de opacidade 0.8/0.7 em terminal/navegador apagavam o texto.
- `QT_QPA_PLATFORMTHEME` declarado duas vezes.
- `GameMode.sh` só mexia no visual e deduzia estado pela opção de animação.

### Não alterado de propósito
Huion (script X11, autostart, regra Xorg, libwacom), KWin, driver NVIDIA, PipeWire,
serviços systemd, governor/scheduler, monitores do KDE (secundário em ~75 Hz), Krita/Blender.
