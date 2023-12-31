local map = vim.api.nvim_set_keymap

-- Move windows with crtl + hjkl
map("n", "<C-h>", "<C-w>h", { noremap = true })
map("n", "<C-j>", "<C-w>j", { noremap = true })
map("n", "<C-k>", "<C-w>k", { noremap = true })
map("n", "<C-l>", "<C-w>l", { noremap = true })

-- Resize windows with crtl + arrows
map("n", "<C-Up>", ":resize +2<CR>", { noremap = true })
map("n", "<C-Down>", ":resize -2<CR>", { noremap = true })
map("n", "<C-Left>", ":vertical resize +2<CR>", { noremap = true })
map("n", "<C-Right>", ":vertical resize -2<CR>", { noremap = true })

-- Move lines up and down with alt + jk
map("n", "<A-j>", ":m .+1<CR>==", { noremap = true })
map("n", "<A-k>", ":m .-2<CR>==", { noremap = true })

-- Change indenation with < and > in visual mode without losing selection
map("v", "<", "<gv", { noremap = true })
map("v", ">", ">gv", { noremap = true })

-- Paste without overwriting the default register
map("n", "<leader>p", '"0p', { noremap = true })
map("v", "<leader>p", '"0p', { noremap = true })

-- Delete without overwriting the default register
map("n", "<leader>d", '"_d', { noremap = true })
map("v", "<leader>d", '"_d', { noremap = true })

-- Shift + hl to move to start/end of line in visual and normal mode
map("n", "<S-h>", "^", { noremap = true })
map("n", "<S-l>", "$", { noremap = true })
map("v", "<S-h>", "^", { noremap = true })
map("v", "<S-l>", "$", { noremap = true })

-- Dealing with word wrap
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { noremap = true, expr = true, silent = true })
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { noremap = true, expr = true, silent = true })

