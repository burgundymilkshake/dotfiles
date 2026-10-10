-- LSP (Language Server Protocol): real code intelligence — go-to-definition,
-- hover docs, rename, diagnostics, etc.
--
--   * mason.nvim          installs language servers for you (:Mason)
--   * mason-lspconfig     bridges mason server names to lspconfig
--   * nvim-lspconfig      ships sensible default configs for each server
return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    { "williamboman/mason.nvim", config = true },
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    -- Lua language server gets extra niceties for editing this very config.
    { "folke/lazydev.nvim", ft = "lua", opts = {} },
  },
  config = function()
    -- Servers to ensure are installed. Add the ones you need; remove what you don't.
    -- Key = lspconfig server name, value = per-server settings table.
    local servers = {
      lua_ls = {
        settings = {
          Lua = {
            completion = { callSnippet = "Replace" },
            diagnostics = { globals = { "vim" } },  -- don't warn about the `vim` global
          },
        },
      },
      pyright = {},   -- Python
      ts_ls = {},     -- TypeScript / JavaScript
      bashls = {},    -- Bash
      -- jsonls = {}, html = {}, cssls = {},   -- uncomment as needed

      -- Go: gopls drives autosuggestions, snippet-style placeholders, and
      -- module/package exploration (workspace symbols, go-to-def into deps).
      gopls = {
        settings = {
          gopls = {
            usePlaceholders = true,            -- expand function args as snippet placeholders
            completeUnimported = true,         -- suggest symbols from not-yet-imported packages
            staticcheck = true,                -- richer diagnostics
            gofumpt = true,                    -- stricter formatting on save
            analyses = {
              unusedparams = true,
              unusedwrite = true,
              nilness = true,
              shadow = true,
            },
            hints = {                          -- inlay hints for params/returns/types
              assignVariableTypes = true,
              compositeLiteralFields = true,
              constantValues = true,
              functionTypeParameters = true,
              parameterNames = true,
              rangeVariableTypes = true,
            },
          },
        },
      },
    }

    require("mason").setup()
    require("mason-tool-installer").setup({
      ensure_installed = vim.tbl_keys(servers),
    })

    -- Extend the completion capabilities with what nvim-cmp supports.
    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    require("mason-lspconfig").setup({
      handlers = {
        function(server_name)
          local opts = servers[server_name] or {}
          opts.capabilities = vim.tbl_deep_extend("force", {}, capabilities, opts.capabilities or {})
          require("lspconfig")[server_name].setup(opts)
        end,
      },
    })

    -- Buffer-local keymaps that only exist once a server attaches to a buffer.
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("core_lsp_attach", { clear = true }),
      callback = function(event)
        local function map(keys, fn, desc)
          vim.keymap.set("n", keys, fn, { buffer = event.buf, desc = "LSP: " .. desc })
        end
        map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
        map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
        map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
        map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
        map("K", vim.lsp.buf.hover, "Hover documentation")
        map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame symbol")
        map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
        map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
      end,
    })

    -- Diagnostics display: virtual text, signs, and a rounded float on hover.
    vim.diagnostic.config({
      virtual_text = { prefix = "●" },
      severity_sort = true,
      float = { border = "rounded", source = true },
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = "✘",
          [vim.diagnostic.severity.WARN] = "▲",
          [vim.diagnostic.severity.HINT] = "⚑",
          [vim.diagnostic.severity.INFO] = "»",
        },
      },
    })
  end,
}
