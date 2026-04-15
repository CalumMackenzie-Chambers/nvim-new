return {
  src = 'https://github.com/ellisonleao/gruvbox.nvim',
  setup = function()
    require('gruvbox').setup({
      contrast = 'hard',
      transparent_mode = true,
    })
    vim.o.background = 'dark'
    vim.cmd.colorscheme('gruvbox')
    vim.api.nvim_set_hl(0, 'StatusLine', { fg = '#ebdbb2', bg = 'NONE' })
  end,
}
