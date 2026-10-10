-- Bootstrap and configure lazy.nvim, the plugin manager.
-- https://github.com/folke/lazy.nvim

-- lazy.nvim installs itself into the data dir on first launch.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", repo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Load every plugin spec under lua/plugins/ and start lazy.
require("lazy").setup({
  spec = { { import = "plugins" } },
  install = { colorscheme = { "tokyonight", "habamax" } },  -- used while plugins install on first run
  checker = { enabled = true, notify = false },             -- quietly check for plugin updates
  change_detection = { notify = false },                    -- don't nag when config files change
  ui = { border = "rounded" },
  performance = {
    rtp = {
      -- Disable some built-in plugins we don't need, for a faster startup.
      disabled_plugins = { "gzip", "tarPlugin", "tohtml", "tutor", "zipPlugin" },
    },
  },
})
