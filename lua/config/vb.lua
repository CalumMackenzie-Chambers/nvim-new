vim.api.nvim_create_autocmd("FileType", {
  pattern = { "vbnet", "vb" },
  callback = function(args)
    local bufnr = args.buf

    vim.treesitter.stop(bufnr)

    vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
    vim.wo.foldenable = false

    -- INFO: The below are really slow,
    vim.lsp.semantic_tokens.enable(false, { bufnr = bufnr })
    vim.lsp.document_color.enable(false, bufnr)

    local clients = vim.lsp.get_clients({ bufnr = bufnr })
    for _, client in pairs(clients) do
      if client.flags then
        client.flags.debounce_text_changes = 1000
      end
    end
  end,
})
