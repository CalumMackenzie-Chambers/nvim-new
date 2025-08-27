return {
  "mason-org/mason.nvim",
  opts = {},
  init = function()
    require("mason").setup({
      registries = {
        "github:mason-org/mason-registry",
        "github:Crashdummyy/mason-registry",
      },
    })
  end,
}
