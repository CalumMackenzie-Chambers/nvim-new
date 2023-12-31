vim.filetype.add({
  extension = {
    postcss = 'css',
  }
})
vim.api.nvim_set_keymap("n", "<space>", "<Nop>", {noremap = true})
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.python3_host_prog = "$HOME/.pyenv/versions/neovim310/bin/python3.10"
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0

local opt = vim.opt

opt.clipboard = "unnamedplus"
opt.cmdheight = 0
opt.colorcolumn = "80"
opt.conceallevel = 0
opt.confirm = true
opt.cursorline = true
opt.expandtab = true
opt.fillchars = { eob = " " }
opt.foldenable = false
opt.grepprg = "rg --vimgrep --no-heading --smart-case"
opt.guicursor = ""
opt.hlsearch = false
opt.laststatus = 0
opt.list = true
opt.mouse = "a"
opt.number = true
opt.pumblend = 20
opt.pumheight = 10
opt.relativenumber = true
opt.scrolloff = 8
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize" }
opt.shiftround = true
opt.shiftwidth = 4
opt.shortmess:append({ W = true, I = true, c = true })
opt.showmode = false
opt.sidescrolloff = 8
opt.signcolumn = "yes"
opt.ignorecase = true
opt.smartcase = true
opt.smartindent = true
opt.splitbelow = true
opt.splitright = true
opt.splitkeep = "screen"
opt.swapfile = false
opt.tabstop = 4
opt.termguicolors = true
opt.undofile = true
opt.undolevels = 10000
opt.updatetime = 200
opt.wildmode = "longest:full,full"
opt.wrap = false
opt.writebackup = false
