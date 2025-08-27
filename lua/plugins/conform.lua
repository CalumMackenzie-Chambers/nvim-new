return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>cf",
      function()
        require("conform").format({ async = true })
      end,
      mode = "",
      desc = "Format buffer",
    },
  },
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      javascript = { "prettier", stop_after_first = true },
      typescript = { "prettier", stop_after_first = true },
      javascriptreact = { "prettier", stop_after_first = true },
      typescriptreact = { "prettier", stop_after_first = true },
      jsx = { "prettier", stop_after_first = true },
      tsx = { "prettier", stop_after_first = true },
      json = { "prettier", stop_after_first = true },
      jsonc = { "prettier", stop_after_first = true },
      html = { "prettier", stop_after_first = true },
      css = { "prettier", stop_after_first = true },
      scss = { "prettier", stop_after_first = true },
      sass = { "prettier", stop_after_first = true },
      less = { "prettier", stop_after_first = true },
      vue = { "prettier", stop_after_first = true },
      svelte = { "prettier", stop_after_first = true },
      astro = { "prettier", stop_after_first = true },
      markdown = { "prettier", stop_after_first = true },
      yaml = { "prettier", stop_after_first = true },
      yml = { "prettier", stop_after_first = true },
      xml = { "prettier", stop_after_first = true },
      graphql = { "prettier", stop_after_first = true },
      handlebars = { "prettier", stop_after_first = true },
      cs = { "csharpier", stop_after_first = true },
    },
    formatters = {
      csharpier = {
        command = "dotnet csharpier",
        args = { "--write-stdout" },
        stdin = true,
      },
    },
    default_format_opts = {
      lsp_format = "fallback",
    },
    format_on_save = { timeout_ms = 500 },
  },
  init = function()
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  end,
}
