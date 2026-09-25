# GERADO por theme/generate.py a partir de theme/palette.json. Não edite; rode `rice-theme`.
typeset -gA MB=(
  ink '#0B0911' bg '#100D18' surface '#191323' raised '#251B35' border '#49365F'
  fg '#EEE8F4' muted '#B0A4BE' subtle '#877A9B'
  purple '#B875F0' purple_neon '#A855F7' zombie '#91C979' green_neon '#B6F36A'
  danger '#FF6B85' warning '#EBCB78' magenta '#DE75BD' cyan '#79CDD0' blue '#8C96F0'
)

# fzf (Ctrl+R, Ctrl+T, Alt+C, **<Tab>)
MB_FZF_COLORS='--color=fg:#EEE8F4,bg:-1,hl:#B6F36A,fg+:#0B0911,bg+:#B6F36A,hl+:#0B0911:bold'\
',info:#877A9B,prompt:#B875F0,pointer:#0B0911,marker:#DE75BD,spinner:#B875F0'\
',header:#B875F0,border:#49365F,label:#B6F36A,query:#EEE8F4,gutter:-1,separator:#49365F,scrollbar:#49365F'

# Item selecionado no menu de completion (verde neon, texto escuro), truecolor em SGR
MB_MENU_SELECT='48;2;182;243;106;38;2;11;9;17;1'
