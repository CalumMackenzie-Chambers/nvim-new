return {
  {
    "rose-pine/neovim",
    name = "rose-pine",
    opts = {
      variant = "moon",
      disable_background = true,
    },
    lazy = false,
    init = function()
      vim.cmd("colorscheme rose-pine")
    end,
  },
}
