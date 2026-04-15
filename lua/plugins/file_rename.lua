return {
  src = 'https://github.com/antosha417/nvim-lsp-file-operations',
  deps = {
    'https://github.com/nvim-lua/plenary.nvim',
    -- neo-tree dep is provided by lua/plugins/neotree.lua
  },
  setup = function()
    require('lsp-file-operations').setup()
  end,
}
