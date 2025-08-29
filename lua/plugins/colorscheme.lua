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
      vim.api.nvim_set_hl(0, 'StatusLine', { fg='#ebdbb2', bg='NONE' })
    end,
  },
}
