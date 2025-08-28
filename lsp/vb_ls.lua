return {
  cmd = { "vb-ls" },
  root_markers = { "*.sln", "*.vbproj" },
  filetypes = { "vbnet" },
  init_options = {
    AutomaticWorkspaceInit = true,
  },
  settings = {
    vb = {
      applyFormattingOptions = false,
    },
  },
  capabilities = (function()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    -- capabilities.textDocument.semanticTokens = nil
    capabilities.textDocument.formatting = nil
    capabilities.textDocument.inlayHint = nil
    -- capabilities.textDocument.documentSymbol = nil
    -- capabilities.workspace.symbol = nil
    return capabilities
  end)(),
  flags = {
    debounce_text_changes = 1000,
  },
}
