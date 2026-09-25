# ── MulletBawbaw // núcleo do zsh ────────────────────────────────────
# Carregado pelo .zshrc DEPOIS do Oh My Zsh (sobrescreve o que precisa).
# Cores: colors.zsh (gerado por ~/my_dots/theme/generate.py).

source "${0:A:h}/colors.zsh"

# ── Silêncio ─────────────────────────────────────────────────────────
# Cada Tab ambíguo emitia um "bell" que o kitty desenhava como flash roxo.
unsetopt BEEP LIST_BEEP HIST_BEEP

# ── Histórico ────────────────────────────────────────────────────────
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
setopt EXTENDED_HISTORY       # grava início e duração de cada comando
setopt SHARE_HISTORY          # compartilha entre terminais abertos
setopt HIST_IGNORE_ALL_DUPS   # remove duplicatas antigas
setopt HIST_IGNORE_SPACE      # comando com espaço na frente não entra no histórico
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY            # !! mostra antes de executar
setopt HIST_FCNTL_LOCK        # lock seguro com vários shells

# ── Comportamento geral ──────────────────────────────────────────────
setopt INTERACTIVE_COMMENTS   # permite # comentários na linha de comando
setopt AUTO_PUSHD PUSHD_IGNORE_DUPS PUSHD_SILENT
setopt NO_FLOW_CONTROL        # Ctrl+S/Ctrl+Q livres
typeset -U path PATH          # PATH sem entradas duplicadas

# ── Completion ───────────────────────────────────────────────────────
setopt COMPLETE_IN_WORD ALWAYS_TO_END AUTO_MENU AUTO_PARAM_SLASH
zmodload zsh/complist

zstyle ':completion:*' menu select
zstyle ':completion:*' rehash true                    # acha binários recém-instalados
zstyle ':completion:*' group-name ''                  # agrupa por tipo
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format "%F{${MB[purple]}}── %d ──%f"
zstyle ':completion:*:corrections'  format "%F{${MB[warning]}}── %d (erros: %e) ──%f"
zstyle ':completion:*:messages'     format "%F{${MB[cyan]}}── %d ──%f"
zstyle ':completion:*:warnings'     format "%F{${MB[danger]}}󰚌 nada encontrado para: %d%f"
zstyle ':completion:*' list-prompt   "%F{${MB[subtle]}}── %p (tab/setas p/ ver mais) ──%f"
zstyle ':completion:*' select-prompt "%F{${MB[subtle]}}── %p ──%f"
# LS_COLORS para arquivos + item ativo do menu em verde neon (ma=)
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS} "ma=${MB_MENU_SELECT}"

# Shift+Tab volta no menu; Esc cancela sem apagar o que foi digitado
bindkey -M menuselect '^[[Z' reverse-menu-complete
bindkey -M menuselect '^[' send-break

# ── Teclas ───────────────────────────────────────────────────────────
bindkey '^ ' autosuggest-accept          # Ctrl+Espaço aceita a sugestão inteira
bindkey '^H' backward-kill-word          # Ctrl+Backspace apaga palavra
bindkey '^[[3;5~' kill-word              # Ctrl+Delete apaga palavra à frente
bindkey '^[[1;5C' forward-word           # Ctrl+→
bindkey '^[[1;5D' backward-word          # Ctrl+←
autoload -Uz edit-command-line && zle -N edit-command-line
bindkey '^X^E' edit-command-line         # abre a linha atual no $EDITOR

# ── Autosuggestions ──────────────────────────────────────────────────
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=40       # não sugere em linhas enormes (coladas)
ZSH_AUTOSUGGEST_USE_ASYNC=1

# ── fzf na paleta ────────────────────────────────────────────────────
if (( $+commands[fzf] )); then
    export FZF_DEFAULT_OPTS="--height=45% --layout=reverse --border=rounded --info=inline-right \
--prompt='󰊠 ' --pointer='▶' --marker='●' --separator='─' ${MB_FZF_COLORS}"
    if (( $+commands[fd] )); then
        export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
        export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND
        export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
    fi
    export FZF_CTRL_R_OPTS="--border-label=' HISTÓRICO ' --header='Ctrl+/ mostra o comando inteiro' \
--preview='echo {2..}' --preview-window=down:3:hidden:wrap --bind='ctrl-/:toggle-preview'"
    source <(fzf --zsh)
fi

# ── ls com ícones e cores do rice ────────────────────────────────────
if (( $+commands[lsd] )); then
    alias ls='lsd'
    alias l='lsd -l'
    alias la='lsd -A'
    alias lla='lsd -lA'
    alias lt='lsd --tree --depth 2'
fi

# ── Pequenos utilitários ─────────────────────────────────────────────
mkcd() { mkdir -p -- "$1" && cd -- "$1"; }
alias sysinfo='fastfetch'   # tela PLAYER STATUS do MulletBawbaw
alias sysinfo-pokemon='pokemon-colorscripts --no-title -s -r | fastfetch -c $HOME/.config/fastfetch/config-pokemon.jsonc --logo-type file-raw --logo-height 10 --logo-width 5 --logo -'
