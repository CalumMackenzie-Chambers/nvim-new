vim.filetype.add({
  extension = {
    templ = "templ",
  },
})
require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.lazy")
