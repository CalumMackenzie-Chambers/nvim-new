return {
  "nvimtools/none-ls.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = { "mason.nvim"},
  opts = function(_, opts)
    local null_ls = require("null-ls")

    local format = null_ls.builtins.formatting
    local lint = null_ls.builtins.diagnostics

    opts.debug = false
    opts.sources = {
      format.stylua,
      format.prettier,
      format.black,
      format.isort,
      format.gofmt,
      lint.flake8,
    }
  end,
}
