return {
  src = 'https://github.com/coder/claudecode.nvim',
  deps = {
    'https://github.com/folke/snacks.nvim',
  },
  setup = function()
    require('snacks').setup({
      terminal = {
        term_norm = {
          '<esc>',
          function(self)
            self.esc_timer = self.esc_timer or (vim.uv or vim.loop).new_timer()
            if self.esc_timer:is_active() then
              self.esc_timer:stop()
              vim.cmd('stopinsert')
            else
              self.esc_timer:start(200, 0, function() end)
              return '<esc>'
            end
          end,
          mode = 't',
          expr = true,
          desc = 'Double escape to normal mode',
        },
      },
    })

    require('claudecode').setup()

    local map = vim.keymap.set
    map('n', '<leader>a',  '', { desc = 'AI/Claude Code' })
    map('n', '<leader>ac', '<cmd>ClaudeCode<cr>',             { desc = 'Toggle Claude' })
    map('n', '<leader>af', '<cmd>ClaudeCodeFocus<cr>',        { desc = 'Focus Claude' })
    map('n', '<leader>ar', '<cmd>ClaudeCode --resume<cr>',    { desc = 'Resume Claude' })
    map('n', '<leader>aC', '<cmd>ClaudeCode --continue<cr>',  { desc = 'Continue Claude' })
    map('n', '<leader>am', '<cmd>ClaudeCodeSelectModel<cr>',  { desc = 'Select Claude model' })
    map('n', '<leader>ab', '<cmd>ClaudeCodeAdd %<cr>',        { desc = 'Add current buffer' })
    map('v', '<leader>as', '<cmd>ClaudeCodeSend<cr>',         { desc = 'Send to Claude' })
    map('n', '<leader>aa', '<cmd>ClaudeCodeDiffAccept<cr>',   { desc = 'Accept diff' })
    map('n', '<leader>ad', '<cmd>ClaudeCodeDiffDeny<cr>',     { desc = 'Deny diff' })

    -- Tree-aware "add file" mapping for file explorer buffers
    vim.api.nvim_create_autocmd('FileType', {
      pattern = { 'NvimTree', 'neo-tree', 'oil', 'minifiles' },
      callback = function(ev)
        vim.keymap.set('n', '<leader>as', '<cmd>ClaudeCodeTreeAdd<cr>',
          { buffer = ev.buf, desc = 'Add file' })
      end,
    })
  end,
}
