# ── MulletBawbaw // prompt zsh ───────────────────────────────────────
#   04:21 󰉋 ~/my_dots 󰘬 rice/mulletbawbaw-v1 ●
#   ❯
# Erro:  󰚌 127 ❯   (caveira + código de saída)
# Usa só vcs_info nativo; cores vêm de colors.zsh (gerado).

source "${0:A:h}/colors.zsh"
autoload -Uz vcs_info add-zsh-hook
setopt prompt_subst

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr   "%F{${MB[green_neon]}}●"
zstyle ':vcs_info:git:*' unstagedstr "%F{${MB[warning]}}●"
zstyle ':vcs_info:git:*' formats       " %F{${MB[zombie]}}󰘬 %b%u%c%f"
zstyle ':vcs_info:git:*' actionformats " %F{${MB[zombie]}}󰘬 %b%f %F{${MB[danger]}}(%a)%u%c%f"
# Arquivos não rastreados também deixam o repo "sujo"
zstyle ':vcs_info:git*+set-message:*' hooks mb-untracked
+vi-mb-untracked() {
    [[ $(git rev-parse --is-inside-work-tree 2>/dev/null) == true ]] || return
    [[ -n $(git ls-files --others --exclude-standard --directory --no-empty-directory 2>/dev/null | head -1) ]] \
        && hook_com[unstaged]+="%F{${MB[magenta]}}?"
}

_mb_precmd() {
    vcs_info
    # Linha em branco entre comandos (menos na primeira)
    [[ -n $_mb_drawn ]] && print ""
    _mb_drawn=1
}
add-zsh-hook precmd _mb_precmd

# Host só aparece em SSH, para não ocupar espaço localmente
_mb_host=""
[[ -n $SSH_CONNECTION ]] && _mb_host="%F{${MB[magenta]}}󰣀 %m%f "

PROMPT='%F{${MB[subtle]}}%D{%H:%M}%f ${_mb_host}%F{${MB[purple]}}󰉋 %(4~|…/%3~|%~)%f${vcs_info_msg_0_}
%(?.%F{${MB[green_neon]}}❯.%F{${MB[danger]}}󰚌 %? ❯)%f '
PROMPT2='%F{${MB[subtle]}}·%f '
RPROMPT=''

# Realce de sintaxe e sugestões na mesma paleta
typeset -gA ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[command]="fg=${MB[zombie]}"
ZSH_HIGHLIGHT_STYLES[builtin]="fg=${MB[zombie]}"
ZSH_HIGHLIGHT_STYLES[alias]="fg=${MB[zombie]}"
ZSH_HIGHLIGHT_STYLES[function]="fg=${MB[zombie]}"
ZSH_HIGHLIGHT_STYLES[precommand]="fg=${MB[zombie]},underline"
ZSH_HIGHLIGHT_STYLES[unknown-token]="fg=${MB[danger]}"
ZSH_HIGHLIGHT_STYLES[reserved-word]="fg=${MB[purple]}"
ZSH_HIGHLIGHT_STYLES[path]="fg=${MB[fg]},underline"
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]="fg=${MB[warning]}"
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]="fg=${MB[warning]}"
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]="fg=${MB[cyan]}"
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]="fg=${MB[cyan]}"
ZSH_HIGHLIGHT_STYLES[comment]="fg=${MB[subtle]}"
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=${MB[subtle]}"
