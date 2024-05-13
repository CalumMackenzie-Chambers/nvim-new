return {
  "SmiteshP/nvim-navic",
  lazy = false,
  opts = function()
    local icons = require("util.icons")

    return {
      icons = icons.kind,
      highlight = true,
      lsp = {
        auto_attach = true,
        preference = { "html" }
      },
      click = true,
      separator = " " .. icons.ui.ChevronRight .. " ",
      depth_limit = 0,
      depth_limit_indicator = "..",
    }
  end,
}
