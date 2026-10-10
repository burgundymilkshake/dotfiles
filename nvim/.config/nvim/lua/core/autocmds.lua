-- Autocommands: things Neovim does automatically in response to events.

-- Put autocommands in a named group so re-sourcing this file clears the old
-- ones first (otherwise they'd stack up and fire multiple times).
local function augroup(name)
  return vim.api.nvim_create_augroup("core_" .. name, { clear = true })
end

-- Briefly highlight text you just yanked — great visual feedback for `yy`, `yiw`, etc.
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  callback = function()
    vim.highlight.on_yank({ timeout = 200 })
  end,
})

-- Strip trailing whitespace on save (skip filetypes where it can be meaningful).
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup("trim_whitespace"),
  callback = function()
    local skip = { markdown = true, diff = true }
    if skip[vim.bo.filetype] then return end
    local save = vim.fn.winsaveview()      -- remember cursor/scroll position
    vim.cmd([[keeppatterns %s/\s\+$//e]])  -- remove trailing whitespace, no error if none
    vim.fn.winrestview(save)               -- restore the view
  end,
})

-- When reopening a file, jump back to where the cursor was last time.
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup("last_location"),
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local lcount = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Auto-create missing parent directories when saving a new file.
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup("auto_create_dir"),
  callback = function(args)
    if args.match:match("^%w%w+://") then return end  -- skip URLs/remote paths
    local file = vim.uv.fs_realpath(args.match) or args.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- Close certain utility/helper buffers with a simple `q`.
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("close_with_q"),
  pattern = { "help", "qf", "man", "lspinfo", "checkhealth", "startuptime" },
  callback = function(args)
    vim.bo[args.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = args.buf, silent = true })
  end,
})

-- Resize splits proportionally if the whole Neovim window is resized.
vim.api.nvim_create_autocmd("VimResized", {
  group = augroup("resize_splits"),
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})
