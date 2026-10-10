-- AsciiDoc preview using tigion/nvim-asciidoc-preview
-- Installs the plugin's Node server (via the `build` step) and provides
-- convenient buffer-local mappings to control the preview.
-- Requires: Node.js (node + npm) and `curl` (see plugin README).

return {
  "tigion/nvim-asciidoc-preview",
  ft = { "asciidoc" },
  -- Install the server dependencies when the plugin is installed/updated.
  build = "cd server && npm install --omit=dev --no-save",

  -- Default options passed to require('asciidoc-preview').setup().
  opts = {
    server = {
      converter = "js",     -- use asciidoctor.js by default (no local asciidoctor needed)
      hostname = "localhost",
      port = 11235,
    },
    preview = {
      position = "current",
      use_asciidoctor_configs = false,
    },
  },

  config = function(_, opts)
    -- Setup the plugin with the provided options.
    local ok, ap = pcall(require, "asciidoc-preview")
    if not ok then
      vim.notify("asciidoc-preview failed to load", vim.log.levels.WARN)
      return
    end
    ap.setup(opts)

    -- Buffer-local mappings for AsciiDoc files.
    local group = vim.api.nvim_create_augroup("AsciidocPreviewMappings", { clear = false })
    vim.api.nvim_create_autocmd("FileType", {
      group = group,
      pattern = "asciidoc",
      callback = function()
        local buf = vim.api.nvim_get_current_buf()
        local map_opts = { buffer = buf, noremap = true, silent = true }
        -- Start preview (open browser)
        vim.keymap.set("n", "<leader>cp", ":AsciiDocPreview<CR>", vim.tbl_extend("force", map_opts, { desc = "AsciiDoc: start preview" }))
        -- Stop preview server
        vim.keymap.set("n", "<leader>cP", ":AsciiDocPreviewStop<CR>", vim.tbl_extend("force", map_opts, { desc = "AsciiDoc: stop preview" }))
        -- Re-open in browser
        vim.keymap.set("n", "<leader>co", ":AsciiDocPreviewOpen<CR>", vim.tbl_extend("force", map_opts, { desc = "AsciiDoc: open preview" }))
        -- Notify server to render current file (if needed)
        vim.keymap.set("n", "<leader>cn", ":AsciiDocPreviewNotify<CR>", vim.tbl_extend("force", map_opts, { desc = "AsciiDoc: notify preview" }))
      end,
    })
  end,
}
