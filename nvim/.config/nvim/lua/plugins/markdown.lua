-- Render Markdown headings, lists, tables, and code blocks in the editor.
return {
  "MeanderingProgrammer/render-markdown.nvim",
  version = "v8.13.0",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  ft = { "markdown", "mdx" },
  opts = {
    file_types = { "markdown", "mdx" },
    heading = { enabled = true },
    code = { enabled = true },
    dash = { enabled = true },
    bullet = { enabled = true },
    checkbox = { enabled = true },
    quote = { enabled = true },
    pipe_table = { enabled = true },
    link = { enabled = true },
    sign = { enabled = true },
    indent = { enabled = true },
    latex = { enabled = false },
    html = { enabled = true },
    win_options = {
      conceallevel = {
        default = 0,
        rendered = 3,
      },
    },
  },
}
