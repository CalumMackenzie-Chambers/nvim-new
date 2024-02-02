return {
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    opts = {
      contrast = "hard",
      transparent_mode = true,
    },
    lazy = false,
    init = function()
      vim.o.background = "dark"
      vim.cmd("colorscheme gruvbox")

      local hl = vim.api.nvim_set_hl

      hl(0, "DiagnosticErrorLn", { bg = "#402120" })
      hl(0, "DiagnosticWarnLn", { bg = "#423821" })
      hl(0, "DiagnosticInfoLn", { bg = "#253436" })
      hl(0, "DiagnosticHintLn", { bg = "#2c3930" })
    end,
  },
}
