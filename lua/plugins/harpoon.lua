return {
  src = 'https://github.com/ThePrimeagen/harpoon',
  version = 'harpoon2',
  setup = function()
    local harpoon = require('harpoon')
    harpoon:setup({
      menu = {
        width = vim.api.nvim_win_get_width(0) - 4,
      },
      settings = {
        save_on_toggle = true,
      },
    })

    local map = vim.keymap.set
    map('n', '<leader>ha', function() harpoon:list():add() end,
      { desc = 'Harpoon Add File' })
    map('n', '<leader>ht', function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
      { desc = 'Harpoon Toggle Menu' })

    -- Workman home row right hand: n, e, o, i for files 1-4
    local workman_keys = { 'n', 'e', 'o', 'i' }
    for i = 1, 4 do
      map('n', '<leader>h' .. workman_keys[i], function() harpoon:list():select(i) end,
        { desc = 'Harpoon to File ' .. i })
    end
  end,
}
