-- nvim-treesitter: better syntax highlighting, indentation, and text objects.
-- It parses code into a syntax tree, which is far more accurate than regex.
return {
  "nvim-treesitter/nvim-treesitter",
  -- Pin to the stable `master` branch. The newer `main`-branch rewrite has a
  -- different, still-evolving API; `master` keeps the well-documented config below.
  branch = "master",
  build = ":TSUpdate",                 -- compile/update parsers after install
  event = { "BufReadPost", "BufNewFile" },
  main = "nvim-treesitter.configs",    -- tell lazy which module's setup() to call with opts
  opts = {
    -- Parsers to always have installed. Add languages you use here.
    ensure_installed = {
      "bash", "c", "lua", "luadoc", "markdown", "markdown_inline",
      "python", "query", "vim", "vimdoc", "json", "yaml", "toml",
      "javascript", "typescript", "tsx", "html", "css",
      "go", "gomod", "gosum", "gowork",
    },
    auto_install = true,               -- install a missing parser when you open a new filetype
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
    indent = { enable = true },        -- use treesitter for `=` indentation
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<C-space>",  -- start expanding the selection
        node_incremental = "<C-space>",
        node_decremental = "<bs>",
      },
    },
  },
}
