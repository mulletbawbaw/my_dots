#!/usr/bin/env python3
"""Converte o MulletBawbaw em pixel art de half-blocks para o dashboard do Neovim.

Gera .config/nvim/lua/mulletbawbaw/art.lua: uma lista de linhas, cada linha uma
lista de trechos {texto, grupo_de_highlight}, mais a tabela de highlights.
Tudo estático: o Neovim só lê a tabela, sem processar imagem em runtime.

Uso: theme/nvim_art.py [colunas] [fração_vertical]   (padrão 44 colunas, 0.50 = cabeça+tronco)
"""
import sys
from pathlib import Path

from PIL import Image

THEME = Path(__file__).resolve().parent
SRC = Path.home() / "Documents/Projects/mulletbawbaw/bawbaw-zombie.png"
OUT = THEME.parent / ".config/nvim/lua/mulletbawbaw/art.lua"
COLS = int(sys.argv[1]) if len(sys.argv) > 1 else 44
CROP = float(sys.argv[2]) if len(sys.argv) > 2 else 0.50


def main():
    img = Image.open(SRC).convert("RGBA")
    img = img.crop(img.getbbox())
    img = img.crop((0, 0, img.width, int(img.height * CROP)))
    img = img.crop(img.getbbox())
    rows = round(img.height / img.width * COLS)
    rows += rows % 2  # half-blocks: 2 pixels por célula
    small = img.resize((COLS, rows), Image.Resampling.BOX)

    alpha = small.getchannel("A")
    rgb = small.convert("RGB")

    def px(x, y):
        # posterização leve (passos de 32) para limitar a quantidade de grupos
        if alpha.getpixel((x, y)) < 110:
            return None
        r, g, b = (min(255, (c // 32) * 32 + 16) for c in rgb.getpixel((x, y)))
        return f"#{r:02X}{g:02X}{b:02X}"

    groups, lines = {}, []
    for y in range(0, rows, 2):
        runs = []
        for x in range(COLS):
            top, bot = px(x, y), px(x, y + 1)
            if top is None and bot is None:
                ch, key = " ", None
            elif bot is None:
                ch, key = "▀", (top, None)
            elif top is None:
                ch, key = "▄", (bot, None)
            else:
                ch, key = "▀", (top, bot)
            name = None
            if key:
                name = groups.setdefault(key, f"MBArt{len(groups)}")
            if runs and runs[-1][1] == name:
                runs[-1][0] += ch
            else:
                runs.append([ch, name])
        # corta espaços à direita (mantém largura visual centralizada pelo dashboard)
        while runs and runs[-1][1] is None and not runs[-1][0].strip():
            runs.pop()
        lines.append(runs)
    while lines and not lines[0]:
        lines.pop(0)
    while lines and not lines[-1]:
        lines.pop()

    width = max(sum(len(t) for t, _ in l) for l in lines)
    out = ["-- GERADO por theme/nvim_art.py a partir de bawbaw-zombie.png. Não edite.",
           "local M = {}", f"M.width = {width}", "M.hl = {"]
    for (fg, bg), name in groups.items():
        bg_s = f', bg = "{bg}"' if bg else ""
        out.append(f'  {name} = {{ fg = "{fg}"{bg_s} }},')
    out.append("}")
    out.append("M.lines = {")
    for l in lines:
        parts = ", ".join(f'{{ "{t}"' + (f', "{n}"' if n else "") + " }" for t, n in l)
        out.append(f"  {{ {parts} }},")
    out.append("}")
    out.append("return M")
    OUT.write_text("\n".join(out) + "\n")
    print(f"gerado: {OUT.relative_to(THEME.parent)} ({width}x{len(lines)} células, {len(groups)} grupos)")


if __name__ == "__main__":
    main()
