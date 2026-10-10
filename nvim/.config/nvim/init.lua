-- ~/.config/nvim/init.lua — the entry point Neovim reads on startup.

-- Set the leader key BEFORE lazy.nvim loads, so plugin mappings pick it up.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Core editor settings (no plugins required).
require("core.options")
require("core.keymaps")
require("core.autocmds")

-- Plugin manager — this loads everything under lua/plugins/.
require("core.lazy")
