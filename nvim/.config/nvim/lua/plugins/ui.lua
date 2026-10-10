-- UI plugins: statusline, git signs in the gutter, indent guides, and a
-- which-key popup that shows available keybindings as you type.
return {
  -- Statusline at the bottom showing mode, branch, diagnostics, position, etc.
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme = "tokyonight",
        component_separators = "|",
        section_separators = "",
        globalstatus = true,  -- a single statusline for all windows
      },
    },
  },

  -- Git change markers in the sign column + hunk navigation/staging.
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "┃" },
        change = { text = "┃" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
      on_attach = function(bufnr)
        local gs = require("gitsigns")
        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
        end
        map("n", "]c", function() gs.nav_hunk("next") end, "Next git hunk")
        map("n", "[c", function() gs.nav_hunk("prev") end, "Previous git hunk")
        map("n", "<leader>hs", gs.stage_hunk, "[H]unk [S]tage")
        map("n", "<leader>hr", gs.reset_hunk, "[H]unk [R]eset")
        map("n", "<leader>hp", gs.preview_hunk, "[H]unk [P]review")
        map("n", "<leader>hb", function() gs.blame_line({ full = true }) end, "[H]unk [B]lame line")
      end,
    },
  },

  -- which-key: pop-up that shows what each leader-prefixed key does.
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      spec = {
        { "<leader>f", group = "[F]ind" },
        { "<leader>h", group = "[H]unk (git)" },
        { "<leader>d", group = "[D]iagnostics/Document" },
        { "<leader>c", group = "[C]ode" },
        { "<leader>r", group = "[R]ename" },
      },
    },
  },

  -- Subtle vertical lines marking indentation levels.
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      indent = { char = "│" },
      scope = { enabled = true },  -- highlight the indent level of the current scope
    },
  },
}
