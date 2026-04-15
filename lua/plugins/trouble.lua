return {
  src = 'https://github.com/folke/trouble.nvim',
  setup = function()
    require('trouble').setup({
      modes = {
        lsp = {
          win = { position = 'right' },
        },
      },
    })

    local map = vim.keymap.set
    map('n', '<leader>dd', '<cmd>Trouble diagnostics toggle<cr>',                 { desc = 'All Diagnostics' })
    map('n', '<leader>db', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',    { desc = 'Buffer Diagnostics' })
    map('n', '<leader>lq', '<cmd>Trouble qflist toggle<cr>',                      { desc = 'Quickfix List' })
    map('n', '<leader>ll', '<cmd>Trouble loclist toggle<cr>',                     { desc = 'Location List' })
    map('n', '<leader>ss', '<cmd>Trouble symbols toggle<cr>',                     { desc = 'Document Symbols' })
    map('n', '<leader>sl', '<cmd>Trouble lsp toggle<cr>',                         { desc = 'LSP References/Definitions' })

    map('n', '[d', function()
      if require('trouble').is_open() then
        require('trouble').prev({ skip_groups = true, jump = true })
      else
        local ok, err = pcall(vim.cmd.cprev)
        if not ok then vim.notify(err, vim.log.levels.ERROR) end
      end
    end, { desc = 'Previous Diagnostic/Quickfix Item' })

    map('n', ']d', function()
      if require('trouble').is_open() then
        require('trouble').next({ skip_groups = true, jump = true })
      else
        local ok, err = pcall(vim.cmd.cnext)
        if not ok then vim.notify(err, vim.log.levels.ERROR) end
      end
    end, { desc = 'Next Diagnostic/Quickfix Item' })
  end,
}
