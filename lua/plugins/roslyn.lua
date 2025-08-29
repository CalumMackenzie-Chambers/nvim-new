return {
  "seblyng/roslyn.nvim",
  ft = { "cs" },
  -- dependencies = {
  --   "tris203/rzls.nvim",
  --   config = true,
  -- },
  config = function()
    -- local rzls_path = vim.fn.expand("$MASON/packages/rzls/libexec")
    local cmd = {
      "roslyn",
      "--stdio",
      "--logLevel=Information",
      "--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.log.get_filename()),
      -- "--razorSourceGenerator=" .. vim.fs.joinpath(rzls_path, "Microsoft.CodeAnalysis.Razor.Compiler.dll"),
      -- "--razorDesignTimePath=" .. vim.fs.joinpath(rzls_path, "Targets", "Microsoft.NET.Sdk.Razor.DesignTime.targets"),
      -- "--extension",
      -- vim.fs.joinpath(rzls_path, "RazorExtension", "Microsoft.VisualStudioCode.RazorExtension.dll"),
    }

    vim.lsp.config("roslyn", {
      filetypes = { "cs" },
      cmd = cmd,
      -- handlers = require("rzls.roslyn_handlers"),
      settings = {
        ["csharp|inlay_hints"] = {
          csharp_enable_inlay_hints_for_implicit_object_creation = true,
          csharp_enable_inlay_hints_for_implicit_variable_types = true,

          csharp_enable_inlay_hints_for_lambda_parameter_types = true,
          csharp_enable_inlay_hints_for_types = true,
          dotnet_enable_inlay_hints_for_indexer_parameters = true,
          dotnet_enable_inlay_hints_for_literal_parameters = true,
          dotnet_enable_inlay_hints_for_object_creation_parameters = true,
          dotnet_enable_inlay_hints_for_other_parameters = true,
          dotnet_enable_inlay_hints_for_parameters = true,
          dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
          dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
          dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
        },
        ["csharp|code_lens"] = {
          dotnet_enable_references_code_lens = true,
        },
      },
    })
    vim.lsp.enable("roslyn")
  end,

  init = function()
    local color = require("util.color")

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "cs",
      callback = function()
        vim.treesitter.stop()
      end,
    })

    vim.filetype.add({
      extension = {
        razor = "razor",
        cshtml = "razor",
      },
    })

    local function setup_csharp_highlights()
      color.create_derived_highlight("Type", "TypeUnderlined", { underline = true })
      color.create_derived_highlight("Function", "FunctionRegular", { bold = false })
    end

    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = setup_csharp_highlights,
    })

    vim.api.nvim_create_autocmd("LspAttach", {
      pattern = "*.cs",
      callback = function()
        local token_mappings = {
          -- Methods and functions
          ["method"] = "FunctionRegular",
          ["extensionMethod"] = "FunctionRegular",

          -- Types
          ["class"] = "Type",
          ["recordClass"] = "Type",
          ["struct"] = "Type",
          ["interface"] = "TypeUnderlined",
          ["enum"] = "Type",
          ["delegate"] = "Type",

          -- Variables and identifiers
          ["variable"] = "Identifier",
          ["parameter"] = "@parameter",
          ["property"] = "Identifier",
          ["field"] = "Identifier",

          -- Keywords
          ["keyword"] = "Keyword",
          ["controlKeyword"] = "Keyword",

          -- Constants and literals
          ["constant"] = "Constant",
          ["enumMember"] = "Constant",

          -- Special
          ["regexGrouping"] = "Special",
          ["namespace"] = "Namespace",
          ["string"] = "String",
          ["number"] = "Number",
          ["comment"] = "Comment",

          -- XML doc comments
          ["xmlDocComment"] = "Comment",
          ["xmlDocCommentName"] = "Comment",
          ["xmlDocCommentDelimiter"] = "Comment",
          ["xmlDocCommentAttributeName"] = "Comment",
          ["xmlDocCommentAttribute"] = "Comment",
          ["xmlDocCommentText"] = "Comment",
        }

        for token_type, hl_group in pairs(token_mappings) do
          vim.api.nvim_set_hl(0, "@lsp.type." .. token_type, { link = hl_group })
        end
      end,
    })

    setup_csharp_highlights()
  end,
}
