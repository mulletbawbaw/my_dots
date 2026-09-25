-- ── MulletBawbaw // ajustes de UI sobre plugins que o LazyVim já traz ──
-- Nenhum plugin novo: só Snacks, Noice, blink.cmp e Lualine configurados.

-- Dashboard: pixel art do personagem (tabela estática gerada por
-- ~/my_dots/theme/nvim_art.py) + título estilo tela de arcade.
local function art_sections()
  local art = require("mulletbawbaw.art")
  local sections = {}
  for _, line in ipairs(art.lines) do
    local chunks, width = {}, 0
    for _, run in ipairs(line) do
      chunks[#chunks + 1] = { run[1], hl = run[2] or "Normal" }
      width = width + vim.fn.strdisplaywidth(run[1])
    end
    -- completa até a largura total para todas as linhas centralizarem juntas
    chunks[#chunks + 1] = { string.rep(" ", art.width - width) }
    sections[#sections + 1] = { text = chunks, align = "center" }
  end
  return sections
end

return {
  {
    "folke/snacks.nvim",
    opts = function(_, opts)
      opts.animate = vim.tbl_deep_extend("force", opts.animate or {}, { fps = 120 })
      -- scroll curto e com desaceleração: acompanha 144 Hz sem "arrastar"
      opts.scroll = vim.tbl_deep_extend("force", opts.scroll or {}, {
        animate = { duration = { step = 10, total = 150 }, easing = "outQuad" },
        animate_repeat = { delay = 100, duration = { step = 4, total = 40 }, easing = "linear" },
      })
      opts.indent = vim.tbl_deep_extend("force", opts.indent or {}, {
        scope = { hl = "SnacksIndentScope" },
        animate = { duration = { step = 12, total = 180 } },
      })
      opts.dashboard = opts.dashboard or {}
      opts.dashboard.sections = function()
        local s = art_sections()
        vim.list_extend(s, {
          { text = { { "M U L L E T B A W B A W", hl = "SnacksDashboardTitle" } }, align = "center", padding = { 0, 1 } },
          { text = { { "// SELECT YOUR QUEST", hl = "SnacksDashboardFooter" } }, align = "center", padding = 1 },
          { section = "keys", gap = 0, padding = 1 },
          { section = "startup" },
        })
        return s
      end
      return opts
    end,
  },

  {
    "folke/noice.nvim",
    opts = { presets = { lsp_doc_border = true } },
  },

  {
    "saghen/blink.cmp",
    opts = {
      completion = {
        menu = { border = "rounded" },
        documentation = { window = { border = "rounded" } },
      },
      signature = { window = { border = "rounded" } },
    },
  },

  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      opts.options = opts.options or {}
      opts.options.theme = "mulletbawbaw"
      opts.options.section_separators = { left = "", right = "" }
      opts.options.component_separators = { left = "│", right = "│" }
      return opts
    end,
  },
}
