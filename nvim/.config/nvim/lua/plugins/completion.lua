-- Autocompletion: nvim-cmp wires together completion sources (LSP, snippets,
-- buffer words, file paths) into the popup menu you see while typing.
return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    -- Snippet engine + a collection of ready-made snippets.
    {
      "L3MON4D3/LuaSnip",
      build = (function()
        -- Optional regex support for snippets; skip on Windows where `make` is rare.
        if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then return end
        return "make install_jsregexp"
      end)(),
      dependencies = { "rafamadriz/friendly-snippets" },
    },
    "saadparwaiz1/cmp_luasnip",  -- snippet source
    "hrsh7th/cmp-nvim-lsp",      -- LSP source
    "hrsh7th/cmp-path",          -- filesystem path source
    "hrsh7th/cmp-buffer",        -- words from the current buffer
  },
  config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")

    -- Load the friendly-snippets collection (lazily, by filetype).
    require("luasnip.loaders.from_vscode").lazy_load()
    luasnip.config.setup({})

    cmp.setup({
      snippet = {
        expand = function(args) luasnip.lsp_expand(args.body) end,
      },
      completion = { completeopt = "menu,menuone,noinsert" },
      mapping = cmp.mapping.preset.insert({
        ["<C-n>"] = cmp.mapping.select_next_item(),  -- next suggestion
        ["<C-p>"] = cmp.mapping.select_prev_item(),  -- previous suggestion
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),     -- scroll docs up
        ["<C-f>"] = cmp.mapping.scroll_docs(4),      -- scroll docs down
        ["<C-Space>"] = cmp.mapping.complete(),      -- force-open the menu
        ["<C-e>"] = cmp.mapping.abort(),             -- close the menu
        ["<CR>"] = cmp.mapping.confirm({ select = true }),  -- accept the highlighted item
        -- Tab / Shift-Tab also jump through snippet placeholders.
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then cmp.select_next_item()
          elseif luasnip.expand_or_locally_jumpable() then luasnip.expand_or_jump()
          else fallback() end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then cmp.select_prev_item()
          elseif luasnip.locally_jumpable(-1) then luasnip.jump(-1)
          else fallback() end
        end, { "i", "s" }),
      }),
      sources = cmp.config.sources({
        { name = "lazydev", group_index = 0 },  -- prioritize lazydev for Lua config editing
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "path" },
      }, {
        { name = "buffer" },
      }),
    })
  end,
}
