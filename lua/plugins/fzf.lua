return {
  src = 'https://github.com/ibhagwan/fzf-lua',
  setup = function()
    require('fzf-lua').setup({
      winopts = {
        width  = 0.8,
        height = 0.8,
        preview = {
          scrollchars = { '┃', '' },
        },
      },
      keymap = {
        fzf = {
          ['ctrl-u'] = 'half-page-up',
          ['ctrl-d'] = 'half-page-down',
          ['ctrl-f'] = 'preview-page-down',
          ['ctrl-b'] = 'preview-page-up',
        },
        builtin = {
          ['<c-f>'] = 'preview-page-down',
          ['<c-b>'] = 'preview-page-up',
        },
      },
      files = {
        cwd_prompt = false,
        cmd = 'fd --type f --hidden --follow --exclude .git',
      },
      grep = {
        rg_opts = '--column --line-number --no-heading --color=always --smart-case --max-columns=4096 -e',
      },
    })

    local map = vim.keymap.set
    map('n', '<leader>ff',  '<cmd>FzfLua files<cr>',                       { desc = 'Find Files' })
    map('n', '<leader>fg',  '<cmd>FzfLua live_grep<cr>',                   { desc = 'Find Grep' })
    map('n', '<leader>fw',  '<cmd>FzfLua grep_cword<cr>',                  { desc = 'Find Word Under Cursor' })
    map('n', '<leader>fad', '<cmd>FzfLua diagnostics_workspace<cr>',       { desc = 'Find All Diagnostics' })
    map('n', '<leader>fbd', '<cmd>FzfLua diagnostics_document<cr>',        { desc = 'Find Buffer Diagnostics' })
    map('n', '<leader>fas', '<cmd>FzfLua lsp_live_workspace_symbols<cr>',  { desc = 'Find All Symbols' })
    map('n', '<leader>fbs', '<cmd>FzfLua lsp_document_symbols<cr>',        { desc = 'Find Buffer Symbols' })
  end,
}
