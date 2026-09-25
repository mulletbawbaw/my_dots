#!/usr/bin/env python3
"""Gera os arquivos de cor do rice MulletBawbaw a partir de theme/palette.json.

Cada template em theme/templates/ começa com uma linha:
    @target <caminho relativo à raiz do my_dots>
O resto do arquivo é copiado, substituindo marcadores {{nome}} ou {{nome|filtro:arg}}.

Nomes:   qualquer chave de "colors", ansi0..ansi15, fonts.<k>, shape.<k>, generated
Filtros: hex      -> RRGGBB
         rgb      -> r, g, b
         kde      -> r,g,b
         sgr      -> r;g;b                  (sequências ANSI truecolor)
         rgba:A   -> rgba(r, g, b, A)       (CSS / Rofi, A entre 0 e 1)
         hypr:AA  -> rgba(RRGGBBAA)         (Hyprland, AA em hex)

Uso:
    generate.py            escreve os arquivos
    generate.py --check    só verifica se estão atualizados (exit 1 se não)
    generate.py --contrast imprime contraste WCAG dos pares usados na interface
"""
import json
import re
import sys
from pathlib import Path

THEME = Path(__file__).resolve().parent
ROOT = THEME.parent
MARK = re.compile(r"\{\{\s*([\w.]+)(?:\|(\w+)(?::([\w.]+))?)?\s*\}\}")
GENERATED = "GERADO por theme/generate.py a partir de theme/palette.json. Não edite; rode `rice-theme`."


def load_values():
    data = json.loads((THEME / "palette.json").read_text())
    values = dict(data["colors"])
    values.update({f"ansi{i}": c for i, c in enumerate(data["ansi"])})
    values.update({f"fonts.{k}": str(v) for k, v in data["fonts"].items()})
    values.update({f"shape.{k}": str(v) for k, v in data["shape"].items()})
    values["generated"] = GENERATED
    return values


def rgb(color):
    return tuple(int(color[i:i + 2], 16) for i in (1, 3, 5))


def apply_filter(value, name, arg):
    if name is None:
        return value
    if not re.fullmatch(r"#[0-9A-Fa-f]{6}", value):
        raise ValueError(f"filtro '{name}' exige cor, recebeu {value!r}")
    r, g, b = rgb(value)
    if name == "hex":
        return value[1:]
    if name == "rgb":
        return f"{r}, {g}, {b}"
    if name == "sgr":
        return f"{r};{g};{b}"
    if name == "kde":
        return f"{r},{g},{b}"
    if name == "rgba":
        return f"rgba({r}, {g}, {b}, {arg})"
    if name == "hypr":
        return f"rgba({value[1:]}{arg})"
    raise ValueError(f"filtro desconhecido: {name}")


def render(template, values):
    first, _, body = template.read_text().partition("\n")
    if not first.startswith("@target "):
        raise ValueError(f"{template.name}: primeira linha deve ser '@target <caminho>'")

    def sub(match):
        key, filt, arg = match.groups()
        if key not in values:
            raise KeyError(f"{template.name}: marcador desconhecido '{key}'")
        return apply_filter(values[key], filt, arg)

    return ROOT / first[len("@target "):].strip(), MARK.sub(sub, body)


def luminance(color):
    def channel(c):
        c /= 255
        return c / 12.92 if c <= 0.03928 else ((c + 0.055) / 1.055) ** 2.4
    r, g, b = (channel(c) for c in rgb(color))
    return 0.2126 * r + 0.7152 * g + 0.0722 * b


def contrast(a, b):
    hi, lo = sorted((luminance(a), luminance(b)), reverse=True)
    return (hi + 0.05) / (lo + 0.05)


def report_contrast(values):
    pairs = [
        ("fg", "bg"), ("fg", "surface"), ("fg", "raised"), ("muted", "bg"), ("muted", "surface"),
        ("subtle", "bg"), ("purple", "bg"), ("purple", "surface"), ("zombie", "bg"),
        ("green_neon", "surface"), ("ink", "green_neon"), ("ink", "purple"), ("danger", "bg"),
        ("warning", "bg"), ("cyan", "bg"), ("blue", "bg"), ("magenta", "bg"),
    ]
    failed = False
    for fg, bg in pairs:
        ratio = contrast(values[fg], values[bg])
        verdict = "AAA" if ratio >= 7 else "AA" if ratio >= 4.5 else "AA-large" if ratio >= 3 else "FAIL"
        failed |= verdict == "FAIL"
        print(f"  {fg:>11} on {bg:<11} {ratio:5.2f}  {verdict}")
    return 1 if failed else 0


def main(argv):
    values = load_values()
    if "--contrast" in argv:
        return report_contrast(values)
    check = "--check" in argv
    stale = 0
    for template in sorted((THEME / "templates").glob("*.tmpl")):
        target, text = render(template, values)
        current = target.read_text() if target.exists() else None
        if current == text:
            continue
        stale += 1
        rel = target.relative_to(ROOT)
        if check:
            print(f"desatualizado: {rel}")
        else:
            target.parent.mkdir(parents=True, exist_ok=True)
            target.write_text(text)
            print(f"gerado: {rel}")
    if check:
        return 1 if stale else 0
    if not stale:
        print("tudo atualizado")
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
