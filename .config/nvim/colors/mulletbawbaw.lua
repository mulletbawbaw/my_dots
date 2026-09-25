-- ── MulletBawbaw // colorscheme ─────────────────────────────────────
-- Reaproveita o motor do gruvbox.nvim (cobertura de treesitter, LSP e
-- plugins) trocando toda a paleta pela do rice (palette.lua é gerado a
-- partir de ~/my_dots/theme/palette.json).
-- vim.g.mb_transparent = false  -> fundo opaco (padrão: deixa o kitty 94% aparecer)
local p = require("mulletbawbaw.palette")

local function blend(fg, bg, alpha)
  local function ch(hex, i) return tonumber(hex:sub(i, i + 1), 16) end
  local out = "#"
  for _, i in ipairs({ 2, 4, 6 }) do
    out = out .. string.format("%02X", math.floor(ch(fg, i) * alpha + ch(bg, i) * (1 - alpha) + 0.5))
  end
  return out
end

local transparent = vim.g.mb_transparent ~= false
local purple = { fg = p.purple }
local keywords = {
  "Keyword", "Statement", "Conditional", "Repeat", "Label", "Exception", "Include", "PreCondit",
  "@keyword", "@keyword.function", "@keyword.return", "@keyword.operator", "@keyword.conditional",
  "@keyword.repeat", "@keyword.exception", "@keyword.import", "@keyword.coroutine",
  "@keyword.modifier", "@keyword.type", "@conditional", "@repeat", "@exception", "@include", "@label",
}

local overrides = {
  -- Base
  Normal = { fg = p.fg, bg = transparent and "NONE" or p.bg },
  NormalNC = { fg = p.fg, bg = transparent and "NONE" or p.bg },
  NormalFloat = { fg = p.fg, bg = p.surface },
  FloatBorder = { fg = p.purple_neon, bg = p.surface },
  FloatTitle = { fg = p.ink, bg = p.green_neon, bold = true },
  WinSeparator = { fg = p.border },
  CursorLine = { bg = blend(p.raised, p.bg, 0.6) },
  CursorLineNr = { fg = p.green_neon, bold = true },
  LineNr = { fg = blend(p.subtle, p.bg, 0.7) },
  SignColumn = { bg = "NONE" },
  Visual = { bg = p.border },
  Search = { fg = p.ink, bg = p.warning },
  IncSearch = { fg = p.ink, bg = p.green_neon, bold = true },
  CurSearch = { fg = p.ink, bg = p.green_neon, bold = true },
  MatchParen = { bg = p.border, bold = true },
  Comment = { fg = p.subtle, italic = true },
  Pmenu = { fg = p.fg, bg = p.surface },
  PmenuSel = { fg = p.ink, bg = p.green_neon, bold = true },
  PmenuSbar = { bg = p.surface },
  PmenuThumb = { bg = p.border },
  StatusLine = { fg = p.muted, bg = p.surface },
  StatusLineNC = { fg = p.subtle, bg = p.bg },
  Title = { fg = p.green_neon, bold = true },
  Directory = { fg = p.purple },
  Folded = { fg = p.muted, bg = p.surface, italic = true },

  -- Sintaxe: roxo p/ controle de fluxo, verde p/ funções/strings (herdado)
  Function = { fg = p.zombie, bold = true },
  ["@function.builtin"] = { fg = p.green_neon },
  ["@variable.builtin"] = { fg = p.magenta, italic = true },
  ["@punctuation.bracket"] = { fg = p.muted },
  ["@punctuation.delimiter"] = { fg = p.muted },

  -- Diagnósticos continuam vermelho/amarelo/azul/verde
  DiagnosticVirtualTextError = { fg = p.danger, bg = blend(p.danger, p.bg, 0.10) },
  DiagnosticVirtualTextWarn = { fg = p.warning, bg = blend(p.warning, p.bg, 0.08) },
  DiagnosticVirtualTextInfo = { fg = p.cyan, bg = blend(p.cyan, p.bg, 0.08) },
  DiagnosticVirtualTextHint = { fg = p.zombie, bg = blend(p.zombie, p.bg, 0.08) },

  -- Diff
  DiffAdd = { bg = blend(p.zombie, p.bg, 0.16) },
  DiffDelete = { bg = blend(p.danger, p.bg, 0.16) },
  DiffChange = { bg = blend(p.blue, p.bg, 0.12) },
  DiffText = { bg = blend(p.blue, p.bg, 0.28) },

  -- Snacks (dashboard, indent, picker, notifier)
  SnacksDashboardHeader = { fg = p.purple_neon },
  SnacksDashboardTitle = { fg = p.green_neon, bold = true },
  SnacksDashboardKey = { fg = p.green_neon, bold = true },
  SnacksDashboardIcon = { fg = p.purple },
  SnacksDashboardDesc = { fg = p.fg },
  SnacksDashboardFooter = { fg = p.subtle, italic = true },
  SnacksDashboardSpecial = { fg = p.magenta },
  SnacksIndent = { fg = blend(p.border, p.bg, 0.45) },
  SnacksIndentScope = { fg = p.purple },
  SnacksPickerBorder = { fg = p.purple_neon, bg = p.surface },
  SnacksPickerTitle = { fg = p.ink, bg = p.green_neon, bold = true },
  SnacksPickerMatch = { fg = p.green_neon, bold = true },
  SnacksPickerDir = { fg = p.subtle },
  SnacksNotifierBorderInfo = { fg = p.purple_neon },
  SnacksNotifierTitleInfo = { fg = p.green_neon, bold = true },
  SnacksNotifierIconInfo = { fg = p.green_neon },

  -- Completion (blink.cmp)
  BlinkCmpMenu = { fg = p.fg, bg = p.surface },
  BlinkCmpMenuBorder = { fg = p.purple_neon, bg = p.surface },
  BlinkCmpMenuSelection = { fg = p.ink, bg = p.green_neon, bold = true },
  BlinkCmpDoc = { bg = p.surface },
  BlinkCmpDocBorder = { fg = p.border, bg = p.surface },
  BlinkCmpLabelMatch = { fg = p.green_neon, bold = true },
  BlinkCmpGhostText = { fg = p.subtle, italic = true },

  -- Noice / which-key / flash / bufferline
  NoiceCmdlinePopupBorder = { fg = p.purple_neon },
  NoiceCmdlinePopupTitle = { fg = p.ink, bg = p.purple, bold = true },
  NoiceCmdlineIcon = { fg = p.green_neon },
  WhichKeyBorder = { fg = p.purple_neon, bg = p.surface },
  WhichKey = { fg = p.green_neon },
  WhichKeyGroup = { fg = p.purple },
  FlashLabel = { fg = p.ink, bg = p.green_neon, bold = true },
  FlashMatch = { fg = p.fg, bg = p.border },
  FlashBackdrop = { fg = p.subtle },
  BufferLineFill = { bg = p.ink },
  BufferLineIndicatorSelected = { fg = p.green_neon },
  GitSignsAdd = { fg = p.zombie },
  GitSignsChange = { fg = p.blue },
  GitSignsDelete = { fg = p.danger },
}
for _, g in ipairs(keywords) do overrides[g] = purple end

require("gruvbox").setup({
  terminal_colors = false, -- o kitty já tem a paleta ANSI do rice
  transparent_mode = transparent,
  italic = { strings = false, emphasis = true, comments = true, operators = false, folds = true },
  palette_overrides = {
    dark0_hard = p.ink, dark0 = p.bg, dark0_soft = p.surface,
    dark1 = p.surface, dark2 = p.raised, dark3 = p.border, dark4 = p.subtle, gray = p.subtle,
    light0_hard = p.fg, light0 = p.fg, light0_soft = p.fg, light1 = p.fg,
    light2 = p.muted, light3 = p.muted, light4 = p.subtle,
    bright_red = p.danger, bright_green = p.zombie, bright_yellow = p.warning,
    bright_blue = p.blue, bright_purple = p.magenta, bright_aqua = p.cyan, bright_orange = p.green_neon,
    neutral_red = p.danger, neutral_green = p.zombie, neutral_yellow = p.warning,
    neutral_blue = p.blue, neutral_purple = p.purple, neutral_aqua = p.cyan, neutral_orange = p.green_neon,
    dark_red = blend(p.danger, p.bg, 0.16), dark_green = blend(p.zombie, p.bg, 0.16),
    dark_aqua = blend(p.cyan, p.bg, 0.16),
  },
  overrides = overrides,
})

vim.o.background = "dark"
require("gruvbox").load()
vim.g.colors_name = "mulletbawbaw"

-- Grupos da pixel art do dashboard
for name, hl in pairs(require("mulletbawbaw.art").hl) do
  vim.api.nvim_set_hl(0, name, hl)
end
