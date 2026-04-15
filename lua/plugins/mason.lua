return {
  src = 'https://github.com/mason-org/mason.nvim',
  setup = function()
    require('mason').setup({
      registries = {
        'github:mason-org/mason-registry',
        'github:Crashdummyy/mason-registry',
      },
    })
  end,
}
