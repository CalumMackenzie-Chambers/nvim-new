local function augroup(name)
  return vim.api.nvim_create_augroup("calum_" .. name, { clear = true })
end

local groupIncsearch = augroup("vimrc-incsearch-highlight")

vim.api.nvim_create_autocmd("CmdlineEnter", {
  group = groupIncsearch,
  pattern = { "/", "?" },
  command = "set hlsearch",
})

vim.api.nvim_create_autocmd("CmdlineLeave", {
  group = groupIncsearch,
  pattern = { "/", "?" },
  command = "set nohlsearch",
})

vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup("checktime"),
  command = "checktime",
})

vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd({ "VimResized" }, {
  group = augroup("resize_splits"),
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup("last_loc"),
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = augroup("close_with_q"),
  pattern = {
    "PlenaryTestPopup",
    "help",
    "lspinfo",
    "man",
    "notify",
    "qf",
    "spectre_panel",
    "startuptime",
    "tsplayground",
    "neotest-output",
    "checkhealth",
    "neotest-summary",
    "neotest-output-panel",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "vbnet", "vb" },
  callback = function(args)
    local bufnr = args.buf

    vim.treesitter.stop(bufnr)

    -- INFO: if performance starts to suck uncomment the following line
    vim.lsp.semantic_tokens.enable(false, { bufnr = bufnr })
    vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
    --
    -- INFO: if performance starts to suck uncomment the following line
    -- vim.lsp.document_color.enable(false, bufnr)
    vim.diagnostic.config({
      update_in_insert = false,
    }, vim.api.nvim_create_namespace("vbnet_diagnostics"))

    vim.wo.foldenable = false

    local clients = vim.lsp.get_clients({ bufnr = bufnr })
    for _, client in pairs(clients) do
      if client.flags then
        client.flags.debounce_text_changes = 1000
      end
    end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = augroup("wrap_spell"),
  pattern = { "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = augroup("auto_create_dir"),
  callback = function(event)
    if event.match:match("^%w%w+://") then
      return
    end
    local file = vim.loop.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnr = args.buf
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "Go to definition" })
    vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, { buffer = bufnr, desc = "Go to type definition" })
    vim.keymap.set("n", "gl", vim.diagnostic.open_float, { buffer = bufnr, desc = "Show line diagnostics" })
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = bufnr, desc = "Go to implementation" })
    vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = bufnr, desc = "Show references" })
    vim.keymap.set({ "n", "v" }, "gca", vim.lsp.buf.code_action, { buffer = bufnr, desc = "Code actions" })
    vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, { buffer = bufnr, desc = "Rename symbol" })
  end,
})
