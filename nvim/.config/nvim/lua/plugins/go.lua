-- Go IDE features built on top of gopls: package/module exploration, doc
-- browsing, struct-tag/impl generation, test running, and auto-imports.
--
-- gopls itself (autosuggestions + snippet placeholders + go-to-definition into
-- module dependencies) is configured in lua/plugins/lsp.lua. This plugin layers
-- the extra "explore the module" commands on top.
return {
  "ray-x/go.nvim",
  dependencies = {
    "ray-x/guihua.lua",            -- floating-window UI used by some pickers
    "neovim/nvim-lspconfig",
    "nvim-treesitter/nvim-treesitter",
  },
  ft = { "go", "gomod", "gosum", "gowork" },
  build = ':lua require("go.install").update_all_sync()',  -- install gopls, dlv, etc.
  opts = {
    lsp_cfg = false,            -- we manage gopls in lsp.lua; don't double-configure
    lsp_keymaps = false,        -- keep our existing LSP keymaps
    lsp_inlay_hints = { enable = true },
    dap_debug = true,
    trouble = false,
  },
  config = function(_, opts)
    require("go").setup(opts)

    -- Format + organize imports on save for Go files.
    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = "*.go",
      group = vim.api.nvim_create_augroup("core_go_format", { clear = true }),
      callback = function() require("go.format").goimports() end,
    })

    -- Go-specific keymaps (only attach in Go buffers).
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "go",
      group = vim.api.nvim_create_augroup("core_go_keymaps", { clear = true }),
      callback = function(ev)
        local function map(keys, cmd, desc)
          vim.keymap.set("n", keys, cmd, { buffer = ev.buf, desc = "Go: " .. desc })
        end
        -- Module / package exploration.
        map("<leader>gd", "<cmd>GoDoc<CR>", "[D]oc for symbol under cursor")
        map("<leader>gp", "<cmd>GoPkgOutline<CR>", "[P]ackage outline / explorer")
        map("<leader>gi", "<cmd>GoImports<CR>", "Organize [I]mports")
        map("<leader>ga", "<cmd>GoAlt<CR>", "[A]lternate file (impl <-> test)")
        -- Tests.
        map("<leader>gt", "<cmd>GoTest<CR>", "[T]est package")
        map("<leader>gtf", "<cmd>GoTestFunc<CR>", "[T]est [f]unction")
        map("<leader>gc", "<cmd>GoCoverage<CR>", "[C]overage")
        -- Code generation.
        map("<leader>gfs", "<cmd>GoFillStruct<CR>", "[F]ill [s]truct")
        map("<leader>ge", "<cmd>GoIfErr<CR>", "Add if-[e]rr block")
        map("<leader>gT", "<cmd>GoAddTag<CR>", "Add struct [T]ags")
      end,
    })
  end,
}
