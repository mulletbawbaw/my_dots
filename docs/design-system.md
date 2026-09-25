# Design system — MulletBawbaw Undead Arcade

**Conceito:** a estação pessoal de um personagem de videogame. Fundo roxo quase preto,
estrutura roxa, verde indicando interação/foco, pequenos detalhes de arcade
("PLAYER 1", "INSERT COIN", "CONTINUE?", "GAME OVER"), sem sacrificar legibilidade.
Os textos funcionais ("Bloquear", "Microfone") continuam literais.

## Fonte única

Tudo nasce em [`theme/palette.json`](../theme/palette.json). Nenhum arquivo de app
contém hex solto: eles importam um arquivo gerado.

```
theme/palette.json ──► theme/generate.py ──► theme/templates/*.tmpl ──► arquivos gerados
                   └─► theme/wallpapers.py  (par de wallpapers)
bawbaw-zombie.png  ──► theme/nvim_art.py    (pixel art do dashboard do Neovim)
```

| Template | Gera | Usado por |
| --- | --- | --- |
| `hypr.tmpl` | `.config/hypr/mulletbawbaw/colors.conf` | Hyprland, hyprlock |
| `css.tmpl` | `.config/mulletbawbaw/colors.css` | Waybar, wlogout |
| `swaync.tmpl` | `.config/swaync/mulletbawbaw-vars.css` | SwayNC (variáveis CSS GTK4) |
| `rofi.tmpl` | `.config/rofi/mulletbawbaw/colors.rasi` | Rofi e todos os menus que importam `config.rasi` |
| `kitty.tmpl` | `.config/kitty/mulletbawbaw.conf` | Kitty (e, via ANSI, Fastfetch/btop/CLI) |
| `lua.tmpl` | `.config/nvim/lua/mulletbawbaw/palette.lua` | colorscheme + lualine |
| `zsh.tmpl` | `.config/zsh/mulletbawbaw/colors.zsh` | prompt e syntax highlighting |
| `kde.tmpl` | `.local/share/color-schemes/MulletBawbaw.colors` | KDE Plasma (e GTK dentro do KDE) |
| `qt6ct.tmpl` | `.config/qt6ct/colors/MulletBawbaw.conf` | apps Qt no Hyprland |
| `gtk.tmpl` | `.config/mulletbawbaw/gtk-colors.css` | apps GTK3/GTK4 no Hyprland |

Comandos:

```sh
rice-theme              # regenera tudo, faz stow de arquivos novos e recarrega apps
rice-theme --check      # só confere se os gerados estão atualizados (exit 1 se não)
rice-theme --contrast   # contraste WCAG dos pares usados na interface
python3 ~/my_dots/theme/wallpapers.py   # regenera wallpapers com a paleta atual
python3 ~/my_dots/theme/nvim_art.py     # regenera a arte do dashboard
```

## Paleta

| Token | Cor | Papel |
| --- | --- | --- |
| `ink` | `#0B0911` | texto sobre verde/roxo, sombras |
| `bg` | `#100D18` | fundo principal |
| `surface` | `#191323` | barra, menus, painéis |
| `raised` | `#251B35` | popups, hover |
| `border` | `#49365F` | bordas inativas, seleção de texto |
| `navy` | `#2B2F5E` | azul do moletom (reserva) |
| `fg` | `#EEE8F4` | texto principal |
| `muted` | `#B0A4BE` | texto secundário |
| `subtle` | `#877A9B` | comentários, dicas, desabilitado |
| `purple` | `#B875F0` | acento roxo legível, palavras-chave |
| `purple_neon` | `#A855F7` | bordas neon, detalhes decorativos |
| `zombie` | `#91C979` | verde da pele: funções, strings, OK |
| `green_neon` | `#B6F36A` | **seleção/foco** (sempre com texto `ink`) |
| `danger` | `#FF6B85` | erro, ações destrutivas |
| `warning` | `#EBCB78` | alerta (óculos amarelos do personagem) |
| `magenta` | `#DE75BD` | detalhe ocasional, constantes |
| `cyan` | `#79CDD0` | informação pontual, links |
| `blue` | `#8C96F0` | identificadores, bluetooth, docker |

Contraste (WCAG, `rice-theme --contrast`): `fg/bg` 16.0, `muted/bg` 8.1, `subtle/bg` 4.8,
`purple/bg` 6.3, `ink/green_neon` 15.1. Nenhum par usado para texto fica abaixo de AA.

Regras:
- Seleção = verde neon com texto quase preto (menu de arcade). Nunca texto verde sobre verde.
- Roxo neon é decorativo (bordas, linhas); texto pequeno usa `purple`, não `purple_neon`.
- Magenta e cyan são tempero, não base. Nada de "pink vaporwave" genérico.

## Forma

| Propriedade | Valor |
| --- | --- |
| Radius | 8 px janelas/painéis, 4 px botões/itens |
| Borda | 2 px (Hyprland: gradiente roxo neon → verde, 45°); painéis têm 2–4 px embaixo (efeito "cartucho") |
| Espaçamento | escala 4/8/12/16 px; gaps Hyprland 4 in / 8 out |
| Sombra | glow roxo 14 px na janela focada, preta nas inativas |
| Blur | 2 passes × 5, só atrás de superfícies transparentes |
| Transparência | kitty 94% (só o fundo); barra 88%; janelas de trabalho 100% opacas |
| Animação | 80–200 ms, curvas com desaceleração forte; overshoot ~5% só na abertura |

## Tipografia e ícones

- **JetBrainsMono Nerd Font** — código, barra, menus, HUD (peso 700–800 em títulos).
- **Noto Sans** — texto corrido de interface (título de janela, corpo de notificação, KDE/Qt/GTK).
- Ícones: glifos **Material Design (nf-md, U+F0000+)** da Nerd Font. Evitamos glifos do
  plano BMP privado (U+E000–F8FF) em arquivos gerados por ferramentas que os descartam.
  Emojis coloridos não são usados na interface.
- Ícones de apps: Breeze Dark. Cursor: Bibata Modern Ice (Hyprland, GTK, KDE).

## Personagem

- Fastfetch: arte completa do zumbi via protocolo gráfico do kitty (`zombie-fetch.png`).
- Neovim: pixel art em half-blocks (cabeça + tronco) gerada estaticamente.
- Wallpaper principal: personagem andando no grid synthwave com "sol zumbi" verde.
- hyprlock: personagem acima do campo de senha.
- Texto: "PLAYER 1/P2", "GAME PAUSED", "INSERT PASSWORD ▸ CONTINUE?", "GAME OVER".
