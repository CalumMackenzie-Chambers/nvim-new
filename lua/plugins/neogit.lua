return {
  "neogitorg/neogit",
  event = "VeryLazy",
  keys = {
    { "<leader>gg", "<cmd>Neogit<CR>", desc = "Neogit" },
  },
  cmd = "Neogit",
  opts = function()
    local icons = require("util.icons")

    return {
      auto_refresh = true,
      disable_builtin_notifications = true,
      use_magit_keybindings = true,
      kind = "tab",
      commit_popup = {
        kind = "split",
      },
      popup = {
        kind = "split",
      },
      signs = {
        section = { icons.ui.ChevronRight, icons.ui.ChevronShortDown },
        item = { icons.ui.ChevronRight, icons.ui.ChevronShortDown },
        hunk = { "", "" },
      },
    }
  end,
}
