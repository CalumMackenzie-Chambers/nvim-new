return {
  'VonHeikemen/lsp-zero.nvim',
  branch = 'v2.x',
  dependencies = {
    {'neovim/nvim-lspconfig'},
    {
      'williamboman/mason.nvim',
      build = function()
        pcall(vim.cmd, 'MasonUpdate')
      end,
    },
    {'williamboman/mason-lspconfig.nvim'},

    {'zbirenbaum/copilot-cmp'},
    {'hrsh7th/nvim-cmp'},
    {'hrsh7th/cmp-buffer'},
    {'hrsh7th/cmp-path'},
    {'saadparwaiz1/cmp_luasnip'},
    {'hrsh7th/cmp-nvim-lsp'},
    {'hrsh7th/cmp-nvim-lua'},

    {'L3MON4D3/LuaSnip'},
    {'rafamadriz/friendly-snippets'},
  },
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require('lspconfig.configs').templ = {
      default_config = {
        name = 'templ',
        cmd = {"templ", "lsp"},
        filetypes = {"templ"},
        root_dir = function()
          return vim.fn.getcwd()
        end,
      },
    }

    require('lspconfig.configs').htmx = {
      default_config = {
        name = 'htmx',
        cmd = {"htmx-lsp", "lsp"},
        filetypes = {"html", "templ"},
        root_dir = function()
          return vim.fn.getcwd()
        end,
      }
    }

    local lsp = require("lsp-zero")

    lsp.preset("recommended")

    lsp.ensure_installed({
      'tsserver',
      'rust_analyzer',
    })

    lsp.nvim_workspace()


    local cmp = require('cmp')
    local cmp_select = {behavior = cmp.SelectBehavior.Select}
    local cmp_mappings = lsp.defaults.cmp_mappings({
      ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
      ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
      ['<C-y>'] = cmp.mapping.confirm({ select = true }),
      ["<C-Space>"] = cmp.mapping.complete(),
    })

    cmp_mappings['<Tab>'] = nil
    cmp_mappings['<S-Tab>'] = nil

    local cmp_sources = {
      {name = 'copilot'},
      {name = 'luasnip', keyword_length = 2},
      {name = 'nvim_lsp', keyword_length = 3},
      {name = 'path'},
      {name = 'buffer', keyword_length = 3},
    }

    lsp.setup_nvim_cmp({
      mapping = cmp_mappings,
      sources = cmp_sources
    })

    lsp.set_sign_icons({
        error = " ",
        warn = " ",
        hint = " ",
        info = " ",
    })

    lsp.on_attach(function(_, bufnr)
      local opts = {buffer = bufnr, remap = false}

      vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
      vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
      vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
      vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
      vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
      vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
      vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
      vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
      vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
      vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
    end)

    require('lspconfig').tailwindcss.setup({
      filetypes = { "aspnetcorerazor", "astro", "astro-markdown", "blade", "clojure", "django-html", "htmldjango", "edge", "eelixir", "elixir", "ejs", "erb", "eruby", "gohtml", "haml", "handlebars", "hbs", "html", "html-eex", "heex", "jade", "leaf", "liquid", "markdown", "mdx", "mustache", "njk", "nunjucks", "php", "razor", "slim", "twig", "css", "less", "postcss", "sass", "scss", "stylus", "sugarss", "javascript", "javascriptreact", "reason", "rescript", "typescript", "typescriptreact", "vue", "svelte", "templ" }
    })

    require('lspconfig').emmet_ls.setup({
      filetypes = { "aspnetcorerazor", "astro", "astro-markdown", "blade", "clojure", "django-html", "htmldjango", "edge", "eelixir", "elixir", "ejs", "erb", "eruby", "gohtml", "haml", "handlebars", "hbs", "html", "html-eex", "heex", "jade", "leaf", "liquid", "markdown", "mdx", "mustache", "njk", "nunjucks", "php", "razor", "slim", "twig", "css", "less", "postcss", "sass", "scss", "stylus", "sugarss", "javascript", "javascriptreact", "reason", "rescript", "typescript", "typescriptreact", "vue", "svelte", "templ" }
    })

    lsp.configure('templ', {force_setup = true})
    lsp.configure('htmx', {force_setup = true})
    lsp.setup()

    vim.diagnostic.config({
      virtual_text = true
    })
  end,
}
