vim.filetype.add({
  extension = {
    templ = "templ",
    aspx = "html",
    ascx = "html",
    Master = "html",
    cshtml = "razor"
  },
})
require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.lazy")
