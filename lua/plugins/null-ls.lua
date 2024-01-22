return {
  "nvimtools/none-ls.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = { "mason.nvim" },
  opts = function()
    local null_ls = require("null-ls")

    local format = null_ls.builtins.formatting
    local lint = null_ls.builtins.diagnostics

    return {
      debug = false,
      sources = {
        format.stylua,
        format.prettier,
        format.black,
        format.isort,
        lint.flake8,
      },
    }
  end,
}
