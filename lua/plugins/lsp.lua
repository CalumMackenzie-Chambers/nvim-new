return {
  "VonHeikemen/lsp-zero.nvim",
  branch = "v3.x",
  dependencies = {
    { "neovim/nvim-lspconfig" },
    { "williamboman/mason.nvim" },
    { "williamboman/mason-lspconfig.nvim" },

    { "zbirenbaum/copilot-cmp" },
    { "hrsh7th/nvim-cmp" },
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-path" },
    { "saadparwaiz1/cmp_luasnip" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/cmp-nvim-lua" },
    {
      "L3MON4D3/LuaSnip",
      dependencies = {
        "rafamadriz/friendly-snippets",
        "unikuragit/vim-vbnet",
      },
      config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
        local vb_path = vim.fn.stdpath("data") .. "/lazy/vim-vbnet/snippet"
        require("luasnip.loaders.from_snipmate").lazy_load({
          paths = { vb_path },
        })
      end,
    },
    {
      "unikuragit/vim-vbnet",
      ft = { "vb", "vbnet" },
      init = function()
        vim.filetype.add({ extension = { vb = "vbnet" } })
      end,
    },
    { "rafamadriz/friendly-snippets" },
    { "CalumMackenzie-Chambers/vim-dadbod-completion" },
  },
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lsp = require("lsp-zero")

    require("mason").setup({})
    require("mason-lspconfig").setup({
      -- stylua: ignore start
      ensure_installed = { "ts_ls", "rust_analyzer", "bashls", "cssls", "emmet_ls", "html", "jsonls", "lua_ls", "marksman", "pyright", "tailwindcss", "templ", "yamlls", },
      handlers = {
        lsp.default_setup,
        lua_ls = function()
          local lua_opts = lsp.nvim_lua_ls()
          require("lspconfig").lua_ls.setup(lua_opts)
        end,
        tailwindcss = function()
          require("lspconfig").tailwindcss.setup({

            -- stylua: ignore start
            filetypes = { "razor", "aspnetcorerazor", "astro", "astro-markdown", "blade", "clojure", "django-html", "htmldjango", "edge", "eelixir", "elixir", "ejs", "erb", "eruby", "gohtml", "haml", "handlebars", "hbs", "html", "html-eex", "heex", "jade", "leaf", "liquid", "markdown", "mdx", "mustache", "njk", "nunjucks", "php", "razor", "slim", "twig", "css", "less", "postcss", "sass", "scss", "stylus", "sugarss", "javascript", "javascriptreact", "reason", "rescript", "typescript", "typescriptreact", "vue", "svelte", "templ" },
          })
        end,
        emmet_ls = function()
          require("lspconfig").emmet_ls.setup({
            -- stylua: ignore start
            filetypes = { "razor", "aspnetcorerazor", "astro", "astro-markdown", "blade", "clojure", "django-html", "htmldjango", "edge", "eelixir", "elixir", "ejs", "erb", "eruby", "gohtml", "haml", "handlebars", "hbs", "html", "html-eex", "heex", "jade", "leaf", "liquid", "markdown", "mdx", "mustache", "njk", "nunjucks", "php", "razor", "slim", "twig", "css", "less", "postcss", "sass", "scss", "stylus", "sugarss", "javascript", "javascriptreact", "reason", "rescript", "typescript", "typescriptreact", "vue", "svelte", "templ" },
          })
        end,
        omnisharp = function()
          require("lspconfig").omnisharp.setup({
            -- stylua: ignore start
            filetypes = { "csharp", "cs", "aspnetcorerazor" },
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
      { name = "luasnip", keyword_length = 2 },
      { name = "nvim_lsp", keyword_length = 3 },
      { name = "path" },
      { name = "buffer", keyword_length = 3 },
    }

    cmp.setup({
      formatting = lsp.cmp_format(),
      mapping = cmp_mappings,
      sources = cmp_sources,
      select = cmp_select,
    })

    cmp.setup.filetype({ "sql" }, {
      sources = {
        { name = "vim-dadbod-completion" },
        { name = "copilot" },
        { name = "buffer", keyword_length = 3 },
      },
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
      local has_def = client.supports_method("textDocument/definition")
      local has_ref = client.supports_method("textDocument/references")
      local pickers = require("telescope.pickers")
      local finders = require("telescope.finders")
      local make_entry = require("telescope.make_entry").gen_from_vimgrep
      local conf = require("telescope.config").values
      local tb = require("telescope.builtin")

      local km = function(lhs, fn, desc)
        vim.keymap.set("n", lhs, fn, { buffer = bufnr, desc = desc })
      end

      -- Core LSP mappings
      keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
      keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
      keymap(bufnr, "n", "gI", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
      keymap(bufnr, "n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
      keymap(bufnr, "n", "<leader>vca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
      keymap(bufnr, "n", "<leader>vrn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
      keymap(bufnr, "n", "<leader>vft", "<cmd>lua vim.lsp.buf.format()<CR>", opts)
      km("gr", function()
        if has_ref then
          return vim.lsp.buf.references()
        end

        local sym = vim.fn.expand("<cword>")
        local curr_file = vim.fn.expand("%:t")

        local curr = vim.fn.systemlist({
          "rg",
          "--vimgrep",
          "-n",
          "-i",
          "--glob",
          curr_file,
          sym,
        })
        local glob = vim.fn.systemlist({
          "rg",
          "--vimgrep",
          "-n",
          "-i",
          "--glob",
          "!*.designer.vb",
          "--glob",
          "!bin/*",
          "--glob",
          "!obj/*",
          sym,
        })
        pickers
          .new({}, {
            prompt_title = "Refs: " .. sym,
            finder = finders.new_table({
              results = vim.list_extend(curr, glob),
              entry_maker = make_entry(),
            }),
            previewer = conf.qflist_previewer({}),
            sorter = conf.generic_sorter({}),
          })
          :find()
      end, "Go to references (LSP or grep; current-file first)")

      -- gd: def or smart grep-fallback in VB with separate scopes
      km("gd", function()
        if has_def then
          return vim.lsp.buf.definition()
        end
        local ft = vim.bo[bufnr].filetype
        if ft == "vb" or ft == "vbnet" then
          local sym = vim.fn.expand("<cword>")

          -- 1) Function/Sub globally
          local func_pat = string.format("(?:Function|Sub)\\s+%s\\b", sym)
          local func_args = {
            "rg",
            "--vimgrep",
            "-n",
            "-i",
            "--glob",
            "*.vb",
            "--glob",
            "!bin/*",
            "--glob",
            "!obj/*",
            "-e",
            func_pat,
          }
          local f_res = vim.fn.systemlist(func_args)
          if vim.v.shell_error == 0 then
            if #f_res == 1 then
              -- jump straight, but place on the symbol, not on "Sub"
              local file, lnum = f_res[1]:match("^([^:]+):(%d+):")
              vim.cmd("edit +" .. lnum .. " " .. file)
              local row = tonumber(lnum)
              local line = vim.api.nvim_buf_get_lines(0, row - 1, row, false)[1]
              local col0 = line:find(sym, 1, true)
              if col0 then
                vim.api.nvim_win_set_cursor(0, { row, col0 - 1 })
              end
              return
            else
              return tb.live_grep({
                prompt_title = "Def (Function/Sub): " .. sym,
                default_text = func_pat,
                additional_args = function()
                  return { "-P", "-i", "--glob", "*.vb", "--glob", "!bin/*", "--glob", "!obj/*" }
                end,
              })
            end
          end

          -- 2) Dim/ReDim/Const only in current file
          local decl_pat = string.format("(?:Dim|ReDim|Const)\\s+%s\\b", sym)
          local curr_file = vim.fn.expand("%:t")
          local decl_args = { "rg", "--vimgrep", "-n", "-i", "--glob", curr_file, "-e", decl_pat }
          local d_res = vim.fn.systemlist(decl_args)
          if vim.v.shell_error == 0 then
            if #d_res == 1 then
              local file, lnum = d_res[1]:match("^([^:]+):(%d+):")
              vim.cmd("edit +" .. lnum .. " " .. file)
              local row = tonumber(lnum)
              local line = vim.api.nvim_buf_get_lines(0, row - 1, row, false)[1]
              local col0 = line:find(sym, 1, true)
              if col0 then
                vim.api.nvim_win_set_cursor(0, { row, col0 - 1 })
              end
              return
            else
              return tb.live_grep({
                prompt_title = "Def (Dim/ReDim/Const): " .. sym,
                default_text = decl_pat,
                additional_args = function()
                  return { "-P", "-i", "--glob", curr_file }
                end,
              })
            end
          end

          -- 3) nothing found
          vim.notify("No definition found for '" .. sym .. "'", vim.log.levels.INFO)
        else
          return vim.lsp.buf.definition()
        end
      end, "Go to definition (smart grep-fallback for VB)")
    end)

    lsp.setup()

    vim.diagnostic.config({
      virtual_text = true,
      underline = false,
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = " ",
          [vim.diagnostic.severity.WARN] = " ",
          [vim.diagnostic.severity.INFO] = " ",
          [vim.diagnostic.severity.HINT] = " ",
        },
        linehl = {
          [vim.diagnostic.severity.ERROR] = "DiagnosticErrorLn",
          [vim.diagnostic.severity.WARN] = "DiagnosticWarnLn",
          [vim.diagnostic.severity.INFO] = "DiagnosticInfoLn",
          [vim.diagnostic.severity.HINT] = "DiagnosticHintLn",
        },
      },
      severity_sort = true,
    })
  end,
}
