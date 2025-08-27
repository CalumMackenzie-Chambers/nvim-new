vim.lsp.config("vb_ls", {
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
    -- INFO: if performance starts to suck uncomment the following line
    -- capabilities.textDocument.semanticTokens = nil

    capabilities.textDocument.inlayHint = nil

    -- INFO: if performance starts to suck uncomment the following line
    -- capabilities.textDocument.documentSymbol = nil

    -- INFO: this means we can't search the whole solution for symbols but it
    -- really slows everything down when it is enabled
    capabilities.workspace.symbol = nil
    return capabilities
  end)(),
  flags = {
    debounce_text_changes = 1000,
  },
})
