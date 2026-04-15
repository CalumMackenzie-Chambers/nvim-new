return {
  src = 'https://github.com/nvim-mini/mini.pairs',
  setup = function()
    require('mini.pairs').setup()

    vim.api.nvim_create_autocmd('FileType', {
      pattern = { 'vb', 'vbnet' },
      callback = function()
        vim.keymap.set('i', "'", "'", { buffer = true })
      end,
    })
  end,
}
