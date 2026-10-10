local opt = vim.opt  -- local alias to keep lines short

opt.number = true          -- Show the absolute line number on the current line
opt.relativenumber = true  -- Show relative numbers on other lines (great for motions like 5j, 12k)

opt.tabstop = 4        -- A <Tab> character displays as 4 spaces wide
opt.softtabstop = 4    -- Pressing <Tab>/<BS> in insert mode acts like 4 spaces
opt.shiftwidth = 4     -- `>>`, `<<`, and auto-indent use 4 spaces per level
opt.expandtab = true   -- Convert pressed <Tab> into spaces (set false if you prefer real tabs)
opt.smartindent = true -- Auto-indent new lines based on syntax (e.g., after `{`)
opt.autoindent = true  -- Copy indent from current line when starting a new one

opt.ignorecase = true  -- Case-insensitive search by default
opt.smartcase = true   -- ...unless the pattern has uppercase letters (then case-sensitive)
opt.hlsearch = true    -- Highlight all matches of the last search
opt.incsearch = true   -- Show matches incrementally as you type

opt.termguicolors = true   -- Enable 24-bit RGB colors (required by most modern colorschemes)
opt.signcolumn = "yes"     -- Always show the sign column (prevents text shifting when LSP/git signs appear)
opt.cursorline = true      -- Highlight the line the cursor is on
opt.scrolloff = 8          -- Keep at least 8 lines visible above/below the cursor when scrolling
opt.sidescrolloff = 8      -- Same, but for horizontal scrolling
opt.wrap = false           -- Don't wrap long lines (they extend horizontally instead)
opt.showmode = false       -- Don't show "-- INSERT --" in command line (statusline plugins will show it later)
opt.cmdheight = 1          -- Height of the command line at the bottom
opt.pumheight = 10         -- Max items shown in completion popup menu

opt.splitright = true  -- `:vsplit` opens the new window to the right (feels natural)
opt.splitbelow = true  -- `:split` opens the new window below

opt.swapfile = false   -- Don't create .swp files (they're annoying; we'll rely on undofile + git)
opt.backup = false     -- Don't keep backup files
opt.undofile = true    -- Persist undo history to disk across sessions (HUGE quality-of-life win)
opt.undolevels = 10000 -- Lots of undo

opt.mouse = "a"               -- Enable mouse in all modes (set "" to disable)
opt.clipboard = "unnamedplus" -- Use the system clipboard for yank/paste (requires xclip/wl-clipboard on Linux)
opt.updatetime = 250          -- Faster CursorHold events (used by LSP, diagnostics, etc.) Default is 4000ms
opt.timeoutlen = 400          -- Time (ms) to wait for a mapped sequence to complete
opt.confirm = true            -- Ask to save changes instead of failing on commands like `:q`

opt.completeopt = { "menuone", "noselect", "noinsert" }

opt.list = true  -- Show invisible characters (tabs, trailing spaces, etc.)
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }  -- How to display them

