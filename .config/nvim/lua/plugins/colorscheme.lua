return {
  -- Motor de cores; carregado sob demanda por colors/mulletbawbaw.lua
  { "ellisonleao/gruvbox.nvim", lazy = true },

  {
    "LazyVim/LazyVim",
    opts = {
      -- Rollback: colorscheme = "gruvbox"
      colorscheme = "mulletbawbaw",
    },
  },
}
