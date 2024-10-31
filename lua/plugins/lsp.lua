return {
  "VonHeikemen/lsp-zero.nvim",
  branch = "v3.x",
  dependencies = {
    { "neovim/nvim-lspconfig" },
    { "williamboman/mason.nvim" },
    { "williamboman/mason-lspconfig.nvim" },
    { "Hoffs/omnisharp-extended-lsp.nvim" },

    { "zbirenbaum/copilot-cmp" },
    { "hrsh7th/nvim-cmp" },
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-path" },
    { "saadparwaiz1/cmp_luasnip" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/cmp-nvim-lua" },

    { "L3MON4D3/LuaSnip" },
    { "rafamadriz/friendly-snippets" },
    { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true },
  },
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lsp = require("lsp-zero")

    require("mason").setup({})
    require("mason-lspconfig").setup({
      -- stylua: ignore start
      ensure_installed = { "ts_ls", "rust_analyzer", "gopls", "bashls", "cssls", "emmet_ls", "html", "jsonls", "lua_ls", "marksman", "pyright", "tailwindcss", "templ", "yamlls", },
      handlers = {
        lsp.default_setup,
        lua_ls = function()
          local lua_opts = lsp.nvim_lua_ls()
          require("lspconfig").lua_ls.setup(lua_opts)
        end,
        tailwindcss = function()
          require("lspconfig").tailwindcss.setup({

            -- stylua: ignore start
            filetypes = { "razor", "astro", "astro-markdown", "blade", "clojure", "django-html", "htmldjango", "edge", "eelixir", "elixir", "ejs", "erb", "eruby", "gohtml", "haml", "handlebars", "hbs", "html", "html-eex", "heex", "jade", "leaf", "liquid", "markdown", "mdx", "mustache", "njk", "nunjucks", "php", "razor", "slim", "twig", "css", "less", "postcss", "sass", "scss", "stylus", "sugarss", "javascript", "javascriptreact", "reason", "rescript", "typescript", "typescriptreact", "vue", "svelte", "templ", },
          })
        end,
        emmet_ls = function()
          require("lspconfig").emmet_ls.setup({
            -- stylua: ignore start
            filetypes = { "razor", "astro", "astro-markdown", "blade", "clojure", "django-html", "htmldjango", "edge", "eelixir", "elixir", "ejs", "erb", "eruby", "gohtml", "haml", "handlebars", "hbs", "html", "html-eex", "heex", "jade", "leaf", "liquid", "markdown", "mdx", "mustache", "njk", "nunjucks", "php", "razor", "slim", "twig", "css", "less", "postcss", "sass", "scss", "stylus", "sugarss", "javascript", "javascriptreact", "reason", "rescript", "typescript", "typescriptreact", "vue", "svelte", "templ", },
          })
        end,
        omnisharp = function()
          require("lspconfig").omnisharp.setup({
            handlers = {
              ["textDocument/definition"] = function(...)
                return require("omnisharp_extended").handler(...)
              end,
            },
            keys = {
              {
                "gd",
                function()
                  require("omnisharp_extended").telescope_lsp_definitions()
                end,
                desc = "Goto Definition",
              },
            },
            enable_roslyn_analyzers = true,
            organize_imports_on_format = true,
            enable_import_completion = true,
          })
        end,
      },
    })

    local cmp = require("cmp")
    local cmp_select = { behavior = cmp.SelectBehavior.Select }
    local cmp_mappings = lsp.defaults.cmp_mappings({
      ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
      ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
      ["<C-y>"] = cmp.mapping.confirm({ select = true }),
      ["<C-Space>"] = cmp.mapping.complete(),
    })

    cmp_mappings["<Tab>"] = nil
    cmp_mappings["<S-Tab>"] = nil

    local cmp_sources = {
      { name = "copilot" },
      { name = "luasnip",  keyword_length = 2 },
      { name = "nvim_lsp", keyword_length = 3 },
      { name = "path" },
      { name = "buffer",   keyword_length = 3 },
    }

    cmp.setup({
      formatting = lsp.cmp_format(),
      mapping = cmp_mappings,
      sources = cmp_sources,
      select = cmp_select,
    })

    cmp.setup.filetype({
      sources = {
        { name = "vim-dadbod-completion" },
        { name = "copilot" },
        { name = "buffer", keyword_length = 3 },
      }
    })

    lsp.set_sign_icons({
      error = " ",
      warn = " ",
      hint = " ",
      info = " ",
    })

    lsp.on_attach(function(client, bufnr)
      local opts = { noremap = true, silent = true }
      local keymap = vim.api.nvim_buf_set_keymap

      keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
      keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
      keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
      keymap(bufnr, "n", "gI", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
      keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
      keymap(bufnr, "n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
      keymap(bufnr, "n", "<leader>vca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
      keymap(bufnr, "n", "<leader>vrn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
      keymap(bufnr, "n", "<leader>vft", "<cmd>lua vim.lsp.buf.format()<CR>", opts)

    end)

    lsp.setup()

    vim.diagnostic.config({
      virtual_text = true,
      underline = false,
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = " ",
          [vim.diagnostic.severity.WARN]  = " ",
          [vim.diagnostic.severity.INFO]  = " ",
          [vim.diagnostic.severity.HINT]  = " ",
        },
        linehl = {
          [vim.diagnostic.severity.ERROR] = "DiagnosticErrorLn",
          [vim.diagnostic.severity.WARN]  = "DiagnosticWarnLn",
          [vim.diagnostic.severity.INFO]  = "DiagnosticInfoLn",
          [vim.diagnostic.severity.HINT]  = "DiagnosticHintLn",
        },
      },
      severity_sort = true,
    })
  end,
}
