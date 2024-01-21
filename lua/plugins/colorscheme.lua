return {
  {
    "rose-pine/neovim",
    version = false,
    name = "rose-pine",
    opts = {
      variant = "moon",
      disable_background = false,
      highlight_groups = {
        NeoTreeDirectoryName = { fg = "rose" },
        NeoTreeDirectoryIcon = { fg = "rose" },
        NeoTreeTabInactive = { fg = "subtle", bg = "none" },
        NeoTreeTabActive = { fg = "rose", bg = "surface" },
        NeoTreeTabSeparatorInactive = { fg = "rose", bg = "none" },
        NeoTreeTabSeparatorActive = { fg = "rose", bg = "surface" },
        SignColumn = { bg = "none" },
        GitSignsAdd = { fg = "pine", bg = "base" },
        GitSignsChange = { fg = "rose", bg = "base" },
        GitSignsDelete = { fg = "love", bg = "base" },
      },
    },
    lazy = false,
    -- init = function()
    --   vim.cmd("colorscheme rose-pine")
    -- end,
  },
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    opts = {
      contrast = "hard",
    },
    lazy = false,
    init = function()
      vim.o.background = "dark"
      vim.cmd("colorscheme gruvbox")
    end,
  },
}
