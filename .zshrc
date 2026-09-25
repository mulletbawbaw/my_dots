# ── MulletBawbaw // .zshrc ───────────────────────────────────────────
# Ordem: PATH → Oh My Zsh (plugins) → núcleo do rice → prompt.
# Personalizações ficam em ~/.config/zsh/mulletbawbaw/ (versionado em ~/my_dots).

# PATH antes de tudo, para plugins e completions enxergarem os binários
export PATH="$HOME/.local/bin:$PATH"          # comandos do rice, Codex installer
export PATH="/usr/lib/ccache/bin:$PATH"       # cache de compilação C/C++

export EDITOR=nvim VISUAL=nvim

# ── Oh My Zsh ────────────────────────────────────────────────────────
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""                                   # prompt próprio (ver prompt.zsh)
# Rollback do prompt: ZSH_THEME="agnosterzak" e comente o source do prompt.zsh
DISABLE_AUTO_TITLE=false
COMPLETION_WAITING_DOTS=false

plugins=(
    git
    archlinux
    zsh-autosuggestions
    zsh-syntax-highlighting   # deve ser o último plugin
)

source "$ZSH/oh-my-zsh.sh"

# ── MulletBawbaw ─────────────────────────────────────────────────────
for _mb in core prompt; do
    if [[ -r ~/.config/zsh/mulletbawbaw/$_mb.zsh ]]; then source ~/.config/zsh/mulletbawbaw/$_mb.zsh; fi
done
unset _mb

# Configurações locais desta máquina (não versionadas), se existirem
if [[ -r ~/.zshrc.local ]]; then source ~/.zshrc.local; fi
true   # primeiro prompt sem código de erro herdado da inicialização
