return {
  "unikuragit/vim-vbnet",
  ft = { "vb", "vbnet" },
  init = function()
    vim.filetype.add({
      extension = {
        vb = "vbnet",
        asax = "vbnet",
      },
    })
  end,
}
