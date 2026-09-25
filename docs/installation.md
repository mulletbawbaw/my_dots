# Reinstalação do zero

Passo a passo para reconstruir o rice MulletBawbaw num Arch novo. Tempo estimado: ~30 min
além da instalação base do Arch.

## 1. Pacotes

```sh
# Sessão Hyprland e interface
sudo pacman -S --needed hyprland hyprlock hypridle xdg-desktop-portal-hyprland \
  waybar rofi swaync wlogout quickshell kitty zsh neovim fastfetch \
  grim slurp swappy cliphist wl-clipboard playerctl pavucontrol blueman \
  network-manager-applet libnotify jq btop nvtop stow git awww

# Aparência compartilhada (Hyprland + KDE)
sudo pacman -S --needed ttf-jetbrains-mono-nerd noto-fonts breeze breeze-gtk qt6ct

# Geradores de tema/wallpaper e runtimes do Mason (LSP)
sudo pacman -S --needed python python-pillow librsvg imagemagick nodejs npm go unzip

# KDE/X11 para trabalho gráfico
sudo pacman -S --needed plasma-meta plasma-x11-session krita blender

# Jogos
sudo pacman -S --needed steam gamemode lib32-gamemode mangohud lib32-mangohud

# AUR (yay)
yay -S bibata-cursor-theme-bin
```

Hoje o cursor Bibata está em `~/.icons/Bibata-Modern-Ice` (instalado à mão, fora do repo).
O pacote AUR acima é o caminho reproduzível.

Oh My Zsh e plugins (não são pacotes):

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
```

## 2. Dotfiles

```sh
git clone <URL> ~/my_dots && cd ~/my_dots
git switch rice/mulletbawbaw-v1          # até ser mesclada na main
stow --target="$HOME" --no-folding --simulate --verbose .   # confira conflitos
stow --target="$HOME" --no-folding .
chsh -s /usr/bin/zsh
```

O personagem vem do repositório `mulletbawbaw` (os geradores leem
`~/Documents/Projects/mulletbawbaw/bawbaw-zombie.png`). Os arquivos já gerados
(wallpapers, `zombie-fetch.png`, `art.lua`) estão versionados, então o clone
funciona mesmo sem esse repositório.

## 3. Aplicar

Dentro do Hyprland:

```sh
rice-theme      # gera cores, aplica GTK/gsettings, recarrega
rice-wall       # par de wallpapers (principal no DP-1)
nvim            # na 1ª abertura o lazy.nvim instala plugins; o Mason instala os LSPs
```

Se o Mason não instalar sozinho:

```sh
nvim --headless -c "lua require('lazy').load({plugins={'mason.nvim'}})" \
  -c "MasonInstall pyright ruff vtsls gopls goimports gofumpt dockerfile-language-server docker-compose-language-service hadolint yaml-language-server json-lsp taplo bash-language-server shellcheck" -c qa
```

Dentro do KDE Plasma (X11), uma vez:

```sh
rice-kde
```

## 4. Coisas específicas desta máquina

| Item | Onde | Observação |
| --- | --- | --- |
| Monitores | `.config/hypr/monitors.conf` | DP-1 Odyssey 1920x1080@143.98 à direita, HDMI-A-1 @60 à esquerda |
| Workspaces | `.config/hypr/workspaces.conf` | 1–5 no DP-1, 6–10 no HDMI-A-1 |
| Waybar | `.config/waybar/config` | barra P1 em `DP-1`, P2 em `!DP-1` |
| Sensor CPU | `mulletbawbaw.modules.jsonc` → `temperature.hwmon-path-abs` | caminho PCI do k10temp; muda em outra placa-mãe |
| Huion H320M | `.local/bin/configure-huion-plasma-x11`, `.config/autostart/huion-plasma-x11.desktop`, `/etc/X11/xorg.conf.d/90-huion-h320m.conf`, `.local/share/libwacom/huion-inspiroy-ink-h320m.tablet` | **fora do repo** — estão no backup; copie manualmente |
| Steam | opções de inicialização do jogo | `gamemoderun %command%` para GameMode real |
