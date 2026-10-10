-- Editing-experience plugins: auto-pairs, commenting, surround, and a file tree.
return {
  -- Automatically insert the closing ) ] } " etc. as you type the opening one.
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({})
      -- Make <CR> inside brackets expand to a properly-indented block, and
      -- let cmp insert `()` after a function completion.
      local ok, cmp = pcall(require, "cmp")
      if ok then
        cmp.event:on("confirm_done", require("nvim-autopairs.completion.cmp").on_confirm_done())
      end
    end,
  },

  -- `gcc` to toggle a line comment, `gc` in visual mode for a selection.
  -- (Neovim 0.10+ ships commenting built in, but Comment.nvim adds gco/gcA, etc.)
  { "numToStr/Comment.nvim", event = "VeryLazy", opts = {} },

  -- Surround text: `ysiw"` to wrap a word in quotes, `cs"'` to change " to ', etc.
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    opts = {},
  },

  -- A file-explorer sidebar. Toggle it with <leader>n.
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    keys = {
      { "<leader>n", "<cmd>NvimTreeToggle<CR>", desc = "Toggle file [N]avigator" },
    },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      view = { width = 32 },
      renderer = { group_empty = true },
      filters = { dotfiles = false },
    },
    config = function(_, opts)
      -- nvim-tree asks that netrw be disabled before it loads.
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
      require("nvim-tree").setup(opts)
    end,
  },
}
