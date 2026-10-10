-- Core key mappings (these don't depend on any plugin).
-- Plugin-specific maps live next to each plugin's spec in lua/plugins/.

-- The leader key is pressed before custom shortcuts (e.g. <leader>w == <Space>w).
-- It must be set before plugins load, which is why it's also set in init.lua,
-- but we keep it here too so this file is self-contained if read on its own.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local map = vim.keymap.set  -- local alias: map(mode, lhs, rhs, opts)

-- Clear search highlight when you press <Esc> in normal mode.
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- Save / quit shortcuts.
map("n", "<leader>w", "<cmd>write<CR>", { desc = "[W]rite (save) file" })
map("n", "<leader>q", "<cmd>quit<CR>", { desc = "[Q]uit window" })

-- Better window navigation: move between splits with Ctrl + h/j/k/l.
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Resize splits with the arrow keys.
map("n", "<C-Up>", "<cmd>resize +2<CR>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<CR>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<CR>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Increase window width" })

-- Move selected lines up/down in visual mode, keeping the selection.
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Keep the cursor centered when jumping half-pages or through search results.
map("n", "<C-d>", "<C-d>zz", { desc = "Half-page down (centered)" })
map("n", "<C-u>", "<C-u>zz", { desc = "Half-page up (centered)" })
map("n", "n", "nzzzv", { desc = "Next search result (centered)" })
map("n", "N", "Nzzzv", { desc = "Prev search result (centered)" })

-- Stay in visual mode after indenting, so you can indent repeatedly.
map("v", "<", "<gv", { desc = "Indent left and reselect" })
map("v", ">", ">gv", { desc = "Indent right and reselect" })

-- Paste over a selection without clobbering your yank register.
map("x", "<leader>p", [["_dP]], { desc = "[P]aste without yanking selection" })

-- jk in insert to go to normal mode
map("i",  "jk", "<Esc>", {desc = "jk to go to normal mode"})
-- Diagnostics navigation (works with the LSP set up in lua/plugins/lsp.lua).
map("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, { desc = "Previous [d]iagnostic" })
map("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, { desc = "Next [d]iagnostic" })
map("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [e]rror" })
map("n", "<leader>dq", vim.diagnostic.setloclist, { desc = "[D]iagnostics to location list" })

-- Floating interactive terminal (built-in, no plugin required).
-- The buffer is kept around between toggles so your shell session persists.
local float_term = { buf = nil, win = nil }

local function toggle_float_term()
  -- If the window is already open, hide it (but keep the terminal running).
  if float_term.win and vim.api.nvim_win_is_valid(float_term.win) then
    vim.api.nvim_win_hide(float_term.win)
    float_term.win = nil
    return
  end

  -- Reuse the existing terminal buffer, or create a fresh one.
  if not (float_term.buf and vim.api.nvim_buf_is_valid(float_term.buf)) then
    float_term.buf = vim.api.nvim_create_buf(false, true)
  end

  -- Size the float to 80% of the editor, centered.
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
  float_term.win = vim.api.nvim_open_win(float_term.buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    style = "minimal",
    border = "rounded",
  })

  -- Start a shell the first time the buffer is shown.
  if vim.bo[float_term.buf].buftype ~= "terminal" then
    vim.fn.jobstart(vim.o.shell, { term = true })
  end
  vim.cmd("startinsert")
end

map("n", "<leader>tt", toggle_float_term, { desc = "[T]oggle floating [t]erminal" })
-- From inside the terminal, drop to normal mode then toggle (hide) the window.
map("t", "<leader>tt", function()
  vim.cmd("stopinsert")
  toggle_float_term()
end, { desc = "[T]oggle floating [t]erminal" })
-- Escape terminal-insert mode back to normal mode.
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
