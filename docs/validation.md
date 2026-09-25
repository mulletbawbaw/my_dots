# Validação — 2026-09-25

Legenda: ✅ verificado nesta sessão · 🟡 verificado parcialmente · ⬜ precisa de teste manual seu

## Medições antes/depois

| Métrica | Antes | Depois | Método |
| --- | --- | --- | --- |
| Zsh startup | 78 ms | 81–83 ms | mediana de 7× `zsh -ic exit` |
| Neovim headless | 39 ms | 44 ms | mediana de 7× `nvim --headless +qa` |
| Neovim até o dashboard | — | 33 ms | contador do próprio Snacks |
| Processos `cava` | 2 permanentes | 0 | `pgrep -c -x cava` |
| Polling de rede na barra | 2 s | 10 s | config |
| Script bluetooth na barra | a cada 10 s | módulo nativo (D-Bus) | config |
| GPU na barra | — | 1 processo `nvidia-smi -l 10` | sem respawn |

O resto do custo novo é GPU (blur 2×5, sombras, animações de ~150 ms), que a RTX 3060 absorve;
o Ryzen não entra no caminho de renderização do compositor.

## Checklist

| Item | Estado | Evidência / como testar |
| --- | --- | --- |
| Hyprland reload | ✅ | `hyprctl configerrors` vazio; animações/blur/sombra ativos |
| 144 Hz principal | ✅ | `DP-1 1920x1080@143.98Hz` |
| 60 Hz secundário | ✅ | `HDMI-A-1 1920x1080@60.000Hz` |
| Binds duplicados | ✅ | `SUPER+W`, `SUPER+SHIFT+setas` com uma ação cada; `SUPER+R` submap |
| Waybar P1/P2 | ✅ | screenshots; todos os glifos renderizam |
| Launcher (Rofi) | ✅ | screenshot; tema herdado pelos 17 menus |
| Notificações | ✅ | `notify-send` + central aberta |
| wlogout | ✅ | visual; ações não executadas |
| kitty | ✅ | tema, transparência, fastfetch com imagem |
| zsh / prompt | ✅ | git branch, dirty, exit code |
| Neovim LSP | ✅ | pyright+ruff, vtsls, gopls, lua_ls anexados em arquivos reais |
| Neovim Treesitter | ✅ | parsers de python/tsx/go/lua ativos |
| Neovim completion | 🟡 | blink.cmp carrega no InsertEnter (headless não entra em insert) |
| GTK (Thunar) | ✅ | screenshot com Breeze + cores do rice |
| Qt no Hyprland | ⬜ | abra um app Qt (ex. `qt6ct`) |
| Overview `SUPER+A` | 🟡 | IPC do Quickshell responde; atalho não pressionado |
| `rice-gaming` | 🟡 | `status`/`waybar` testados; `on/off` não disparados durante o seu jogo |
| Lock (hyprlock) | ⬜ | `Ctrl+Alt+L`. Saída de emergência: `Ctrl+Alt+F3` → `pkill hyprlock` |
| Sleep/resume | ⬜ | `wlogout` → Suspender (agora `systemctl suspend`) |
| KDE/X11 login | ⬜ | entrar no Plasma X11 e rodar `rice-kde` |
| Huion | ⬜ (não alterada) | pressão/botões no Krita |
| Krita / Blender / Aseprite | ⬜ (não alterados) | abrir e desenhar/renderizar |
| Steam / Proton / Vulkan | ⬜ | jogo com `gamemoderun %command%` |
| Áudio / Bluetooth | 🟡 | módulos na barra refletem estado; troca de rota não testada |
| Screenshots | 🟡 | `grim` funciona; `SUPER+SHIFT+S` (swappy) não pressionado |
| Screen sharing | ⬜ | portal não alterado |
| Clipboard | ⬜ (não alterado) | cliphist continua no startup |
| Logout / reboot | ⬜ | — |
