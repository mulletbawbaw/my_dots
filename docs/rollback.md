# Rollback

Três níveis, do mais leve ao mais completo.

## 1. Desligar uma parte (sem git)

| Parte | Como voltar |
| --- | --- |
| Hyprland (visual, animações, binds novos) | comente `source = …/mulletbawbaw/rice.conf` no fim de `hyprland.conf` e `hyprctl reload` |
| Prompt zsh | em `.zshrc`: `ZSH_THEME="agnosterzak"` e remova a linha `source …/prompt.zsh` |
| Neovim | em `lua/plugins/colorscheme.lua`: `colorscheme = "gruvbox"` |
| Neovim fundo opaco | `vim.g.mb_transparent = false` em `lua/config/options.lua` |
| Wallpaper | `SUPER+W` e escolha outro, ou `rice-wall ~/Pictures/wallpapers/<arquivo>` |
| Modo jogo preso | `rice-gaming off` (faz `hyprctl reload`) |
| KDE | dentro do Plasma: `rice-kde --undo` |
| Qt no Hyprland | em `qt6ct.conf`: `style=kvantum` e `color_scheme_path=…/Catppuccin-Mocha.conf` |
| GTK no Hyprland | `gsettings set org.gnome.desktop.interface gtk-theme 'Flat-Remix-GTK-Blue-Dark'` |
| Lock screen travado | `Ctrl+Alt+F3`, login, `pkill hyprlock` (ou `loginctl unlock-sessions`) |

## 2. Git

Todo o trabalho está na branch `rice/mulletbawbaw-v1`. A `main` está intocada.

```sh
cd ~/my_dots
git switch main                                # volta tudo
stow --target="$HOME" --no-folding --restow .  # religa (arquivos só da branch viram links quebrados)
find ~/.config ~/.local -xtype l -lname '*my_dots*' -print   # lista links quebrados para remover
hyprctl reload; pkill -SIGUSR2 waybar; swaync-client -R -rs
```

Commits da branch (use `git revert <hash>` para desfazer só um):

| Commit | Conteúdo |
| --- | --- |
| `5a3be24` | baseline: as 9 alterações locais que já existiam antes do rice |
| `24f9a92` | design system, kitty, zsh, fastfetch, wallpapers, hyprland, waybar, rofi |
| `c44a7c7` | swaync, wlogout, hyprlock |
| `fd915c6` | neovim: colorscheme, dashboard, LSP |
| `f109668` | KDE/Qt/GTK, docs |

Mudanças feitas **fora** do git (restaure manualmente se voltar para `main`):

- `~/.zshrc` passou a ser link para `my_dots/.zshrc` (original no backup).
- `~/.config/user-dirs.dirs` virou link (conteúdo idêntico + `XDG_PROJECTS_DIR`).
- `~/.config/gtk-{3,4}.0/colors.css` sobrescritos pelo `rice-theme` (o KDE os regrava ao aplicar um esquema).
- `gsettings` de interface (tema GTK Breeze, cursor Bibata, ícones breeze-dark, fontes).
- `~/.config/hypr/current_wallpaper` aponta para o par MulletBawbaw.
- Servidores LSP instalados pelo Mason em `~/.local/share/nvim/mason`.

## 3. Backup completo

`~/.local/share/rice-backups/2026-09-25_04-15/` (permissão 700):

| Arquivo | O que é |
| --- | --- |
| `before-rice.tar.gz` | snapshot de `my_dots`, `.zshrc`, `.oh-my-zsh`, `.config/{hypr,waybar,kitty,nvim,rofi,swaync,…}`, KDE rc, Huion (`.local/bin`, libwacom, autostart, `/etc/X11/xorg.conf.d`), wallpapers, projeto mulletbawbaw |
| `manifest.json` | hash sha256 de cada arquivo + alvos de symlink |
| `my_dots.bundle` | `git bundle` com todas as branches |
| `git-working.patch` | as alterações não commitadas que existiam antes |
| `SHA256SUMS`, `verification.json` | verificação (85.087 itens, PASS) |

Restaurar um arquivo específico:

```sh
cd ~/.local/share/rice-backups/2026-09-25_04-15
tar -tzf before-rice.tar.gz | grep kitty.conf
tar -xzf before-rice.tar.gz -C / home/bawkare/.zshrc     # exemplo
```
