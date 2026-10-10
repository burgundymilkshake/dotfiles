-- Telescope: a fuzzy finder for files, text, buffers, help, and much more.
return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  cmd = "Telescope",
  dependencies = {
    "nvim-lua/plenary.nvim",
    -- Native C sorter for much faster fuzzy matching (needs `make`).
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      cond = function() return vim.fn.executable("make") == 1 end,
    },
    "nvim-tree/nvim-web-devicons",  -- file-type icons (needs a Nerd Font)
  },
  keys = {
    { "<leader>ff", "<cmd>Telescope find_files<CR>",  desc = "[F]ind [F]iles" },
    { "<leader>fg", "<cmd>Telescope live_grep<CR>",   desc = "[F]ind by [G]rep" },
    { "<leader>fb", "<cmd>Telescope buffers<CR>",     desc = "[F]ind [B]uffers" },
    { "<leader>fh", "<cmd>Telescope help_tags<CR>",   desc = "[F]ind [H]elp" },
    { "<leader>fr", "<cmd>Telescope oldfiles<CR>",    desc = "[F]ind [R]ecent files" },
    { "<leader>fw", "<cmd>Telescope grep_string<CR>", desc = "[F]ind [W]ord under cursor" },
    { "<leader>fd", "<cmd>Telescope diagnostics<CR>", desc = "[F]ind [D]iagnostics" },
    { "<leader>fk", "<cmd>Telescope keymaps<CR>",     desc = "[F]ind [K]eymaps" },
    { "<leader><leader>", "<cmd>Telescope find_files<CR>", desc = "Find files (quick)" },
    { "<leader>/", "<cmd>Telescope current_buffer_fuzzy_find<CR>", desc = "Search in current buffer" },
  },
  config = function()
    local telescope = require("telescope")
    telescope.setup({
      defaults = {
        path_display = { "truncate" },
        mappings = {
          i = { ["<C-u>"] = false },  -- let <C-u> clear the prompt line
        },
      },
    })
    pcall(telescope.load_extension, "fzf")  -- enable the native sorter if it built
  end,
}
