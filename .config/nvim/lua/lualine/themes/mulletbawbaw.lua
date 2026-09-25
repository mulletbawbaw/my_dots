-- Tema lualine do MulletBawbaw (carregado automaticamente com theme = "auto")
local p = require("mulletbawbaw.palette")
local function mode(accent)
  return {
    a = { fg = p.ink, bg = accent, gui = "bold" },
    b = { fg = p.fg, bg = p.raised },
    c = { fg = p.muted, bg = p.surface },
  }
end
return {
  normal = mode(p.green_neon),
  insert = mode(p.purple),
  visual = mode(p.magenta),
  replace = mode(p.danger),
  command = mode(p.warning),
  terminal = mode(p.cyan),
  inactive = {
    a = { fg = p.subtle, bg = p.surface },
    b = { fg = p.subtle, bg = p.surface },
    c = { fg = p.subtle, bg = p.bg },
  },
}
