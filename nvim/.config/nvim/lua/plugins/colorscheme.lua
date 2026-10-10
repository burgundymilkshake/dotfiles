-- Colorscheme: tokyonight (dark, easy on the eyes, well-maintained).
-- To try another style, change `style` to "storm", "moon", "night", or "day".
return {
  "folke/tokyonight.nvim",
  lazy = false,    -- load during startup (the colorscheme should apply immediately)
  priority = 1000, -- load before other plugins so highlights are set early
  opts = {
    style = "night",
    transparent = false,
    styles = {
      comments = { italic = true },
      keywords = { italic = false },
    },
  },
  config = function(_, opts)
    require("tokyonight").setup(opts)
    vim.cmd.colorscheme("tokyonight")
  end,
}
