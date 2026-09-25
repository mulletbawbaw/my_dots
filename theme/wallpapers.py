#!/usr/bin/env python3
"""Gera o par de wallpapers MulletBawbaw (1920x1080) a partir de palette.json.

main.png  -> monitor principal (Odyssey, DP-1): sol zumbi + grid + personagem
side.png  -> secundário (HDMI-A-1): mesmo horizonte, sem sol nem personagem

Dependências já instaladas: rsvg-convert (librsvg) e magick (ImageMagick).
A arte é escura no centro para não brigar com janelas e texto.
"""
import json
import subprocess
import tempfile
from pathlib import Path

THEME = Path(__file__).resolve().parent
OUT = THEME.parent / ".local/share/mulletbawbaw/wallpapers/undead-arcade"
ZOMBIE = Path.home() / "Documents/Projects/mulletbawbaw/bawbaw-zombie.png"
W, H, HORIZON = 1920, 1080, 640
C = json.loads((THEME / "palette.json").read_text())["colors"]


def grid(vx):
    """Chão em perspectiva com ponto de fuga em (vx, HORIZON)."""
    lines = []
    for i in range(-26, 27):  # linhas radiais
        x = vx + i * 150
        lines.append(f'<line x1="{vx}" y1="{HORIZON}" x2="{x}" y2="{H}"/>')
    y, step = HORIZON + 6, 6
    while y < H:  # linhas horizontais cada vez mais espaçadas
        lines.append(f'<line x1="0" y1="{y:.0f}" x2="{W}" y2="{y:.0f}"/>')
        step *= 1.32
        y += step
    return "\n".join(lines)


def stars(seed, n):
    import random
    rnd = random.Random(seed)
    out = []
    for _ in range(n):
        x, y = rnd.randrange(W), rnd.randrange(HORIZON - 40)
        s = rnd.choice((2, 2, 2, 4))  # "pixels" quadrados, estilo 8-bit
        col = rnd.choice((C["fg"], C["purple"], C["green_neon"], C["muted"]))
        out.append(f'<rect x="{x}" y="{y}" width="{s}" height="{s}" fill="{col}" opacity="{rnd.uniform(.25, .8):.2f}"/>')
    return "\n".join(out)


def sun(cx, cy, r):
    """Sol synthwave clássico, só que verde (zumbi) e cortado por faixas."""
    cuts = []
    for k in range(7):
        y = cy - r * 0.62 + k * (r * 0.1)
        h = 2 + k * 2.6
        cuts.append(f'<rect x="{cx - r}" y="{y:.0f}" width="{2 * r}" height="{h:.0f}" fill="black"/>')
    return f"""
  <mask id="suncut"><rect width="{W}" height="{H}" fill="white"/>{''.join(cuts)}</mask>
  <circle cx="{cx}" cy="{cy}" r="{r + 60}" fill="url(#halo)"/>
  <circle cx="{cx}" cy="{cy}" r="{r}" fill="url(#sun)" mask="url(#suncut)"/>"""


def svg(main):
    vx = 1180 if main else W // 2
    sun_svg = sun(1180, HORIZON - 20, 250) if main else ""
    label = "MULLETBAWBAW // PLAYER 1" if main else "PLAYER 2 // STANDBY"
    return f"""<svg xmlns="http://www.w3.org/2000/svg" width="{W}" height="{H}">
  <defs>
    <linearGradient id="sky" x1="0" y1="0" x2="0" y2="1">
      <stop offset="0" stop-color="{C['ink']}"/>
      <stop offset=".55" stop-color="{C['bg']}"/>
      <stop offset="1" stop-color="{C['raised']}"/>
    </linearGradient>
    <linearGradient id="floor" x1="0" y1="0" x2="0" y2="1">
      <stop offset="0" stop-color="{C['surface']}"/>
      <stop offset="1" stop-color="{C['ink']}"/>
    </linearGradient>
    <linearGradient id="gridfade" x1="0" y1="0" x2="0" y2="1">
      <stop offset="0" stop-color="{C['purple_neon']}" stop-opacity=".9"/>
      <stop offset="1" stop-color="{C['purple_neon']}" stop-opacity=".25"/>
    </linearGradient>
    <linearGradient id="sun" x1="0" y1="0" x2="0" y2="1">
      <stop offset="0" stop-color="{C['green_neon']}"/>
      <stop offset=".55" stop-color="{C['zombie']}"/>
      <stop offset="1" stop-color="{C['purple']}"/>
    </linearGradient>
    <radialGradient id="halo">
      <stop offset=".6" stop-color="{C['green_neon']}" stop-opacity=".18"/>
      <stop offset="1" stop-color="{C['green_neon']}" stop-opacity="0"/>
    </radialGradient>
    <linearGradient id="haze" x1="0" y1="0" x2="0" y2="1">
      <stop offset="0" stop-color="{C['purple_neon']}" stop-opacity="0"/>
      <stop offset="1" stop-color="{C['purple_neon']}" stop-opacity=".35"/>
    </linearGradient>
  </defs>
  <rect width="{W}" height="{HORIZON}" fill="url(#sky)"/>
  {stars(7 if main else 11, 110 if main else 70)}
  {sun_svg}
  <rect y="{HORIZON - 90}" width="{W}" height="90" fill="url(#haze)"/>
  <rect y="{HORIZON}" width="{W}" height="{H - HORIZON}" fill="url(#floor)"/>
  <g stroke="url(#gridfade)" stroke-width="2">{grid(vx)}</g>
  <rect y="{HORIZON - 2}" width="{W}" height="4" fill="{C['purple_neon']}"/>
  <rect y="{HORIZON - 1}" width="{W}" height="1" fill="{C['fg']}" opacity=".7"/>
  <defs><pattern id="scan" width="4" height="3" patternUnits="userSpaceOnUse">
    <rect y="2" width="4" height="1" fill="#000" opacity=".22"/></pattern></defs>
  <rect width="{W}" height="{H}" fill="url(#scan)"/>
  <text x="{W - 48}" y="{H - 40}" text-anchor="end" font-family="JetBrainsMono Nerd Font"
        font-weight="800" font-size="20" letter-spacing="4" fill="{C['muted']}" opacity=".55">{label}</text>
</svg>"""


def build(name, main):
    with tempfile.TemporaryDirectory() as tmp:
        base = Path(tmp) / "base.png"
        (Path(tmp) / "w.svg").write_text(svg(main))
        subprocess.run(["rsvg-convert", "-o", base, Path(tmp) / "w.svg"], check=True)
        cmd = ["magick", base]
        if main and ZOMBIE.exists():
            # personagem à esquerda, "em pé" no grid, com sombra roxa no chão
            cmd += ["(", ZOMBIE, "-trim", "+repage", "-resize", "x640", ")",
                    "-geometry", "+90+410", "-composite"]
        cmd += ["-strip", OUT / name]
        subprocess.run(cmd, check=True)
        print(f"gerado: {OUT / name}")


if __name__ == "__main__":
    OUT.mkdir(parents=True, exist_ok=True)
    build("main.png", True)
    build("side.png", False)
