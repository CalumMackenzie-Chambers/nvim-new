return {
  "lewis6991/gitsigns.nvim",
  opts = {
    signs = {
      add = { text = "▎" },
      change = { text = "▎" },
      delete = { text = "" },
      topdelete = { text = "" },
      changedelete = { text = "▎" },
      untracked = { text = "▎" },
    },
    signs_staged = {
      add = { text = "▎" },
      change = { text = "▎" },
      delete = { text = "" },
      topdelete = { text = "" },
      changedelete = { text = "▎" },
    },
    signs_staged_enable = true,
    signcolumn = true,
    current_line_blame = true,

    current_line_blame_opts = {
      ignore_whitespace = true,
    },
    sign_priority = 6
  },
  config = function(_, opts)
    require("gitsigns").setup(opts)
    vim.api.nvim_set_hl(0, 'SignColumn', { bg = 'NONE' })
  end,
}
