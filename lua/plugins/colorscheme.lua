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
    end,
  },
}
