-- nvim-treesitter: better syntax highlighting, indentation, and text objects.
-- It parses code into a syntax tree, which is far more accurate than regex.
return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    require("nvim-treesitter").setup({
      ensure_installed = {
        "bash", "c", "lua", "luadoc", "markdown", "markdown_inline",
        "python", "query", "vim", "vimdoc", "json", "yaml", "toml",
        "javascript", "typescript", "tsx", "html", "css",
        "go", "gomod", "gosum", "gowork",
      },
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          node_decremental = "<bs>",
        },
      },
    })
  end,
}
