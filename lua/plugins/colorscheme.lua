return {
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    opts = {
      contrast = "hard",
      transparent_mode = false,
    },
    lazy = false,
    init = function()
      vim.o.background = "dark"
      vim.cmd("colorscheme gruvbox")

      local hl = vim.api.nvim_set_hl

      if vim.o.background == "dark" then
        hl(0, "DiagnosticErrorLn", { bg = "#402120" })
        hl(0, "DiagnosticWarnLn", { bg = "#423821" })
        hl(0, "DiagnosticInfoLn", { bg = "#253436" })
        hl(0, "DiagnosticHintLn", { bg = "#2c3930" })
      else
        hl(0, "DiagnosticErrorLn", { bg = "#f2c8a5" })
        hl(0, "DiagnosticWarnLn",  { bg = "#f4dfa6" })
        hl(0, "DiagnosticInfoLn",  { bg = "#d6d9b1" })
        hl(0, "DiagnosticHintLn",  { bg = "#cad5b7" })
      end
    end,
  },
}
