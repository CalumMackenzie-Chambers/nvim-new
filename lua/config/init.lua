vim.filetype.add({
  extension = {
    templ = "templ",
    aspx = "html",
    ascx = "html",
    Master = "html",
    vb = "vbnet",
  },
})

require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.vb")
require("config.diagnostics")
require("config.lazy")

vim.lsp.config("*", {
  root_markers = { ".git" },
})

vim.lsp.enable({
  "luals",
  "vb_ls"
})
