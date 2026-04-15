return {
  src = 'https://github.com/seblyng/roslyn.nvim',
  setup = function()
    local color = require('util.color')

    vim.filetype.add({
      extension = {
        razor  = 'razor',
        cshtml = 'razor',
      },
    })

    local cmd = {
      'roslyn',
      '--stdio',
      '--logLevel=Information',
      '--extensionLogDirectory=' .. vim.fs.dirname(vim.lsp.log.get_filename()),
    }

    vim.lsp.config('roslyn', {
      filetypes = { 'cs' },
      cmd = cmd,
      settings = {
        ['csharp|inlay_hints'] = {
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
        ['csharp|code_lens'] = {
          dotnet_enable_references_code_lens = true,
        },
      },
    })
    vim.lsp.enable('roslyn')

    -- Treesitter is intentionally disabled for C# in favour of Roslyn's
    -- semantic tokens (see token_mappings below).
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'cs',
      callback = function() vim.treesitter.stop() end,
    })

    local function setup_csharp_highlights()
      color.create_derived_highlight('Type', 'TypeUnderlined', { underline = true })
      color.create_derived_highlight('Function', 'FunctionRegular', { bold = false })
    end

    vim.api.nvim_create_autocmd('ColorScheme', { callback = setup_csharp_highlights })
    setup_csharp_highlights()

    vim.api.nvim_create_autocmd('LspAttach', {
      pattern = '*.cs',
      callback = function()
        local token_mappings = {
          ['method']                     = 'FunctionRegular',
          ['extensionMethod']            = 'FunctionRegular',
          ['class']                      = 'Type',
          ['recordClass']                = 'Type',
          ['struct']                     = 'Type',
          ['interface']                  = 'TypeUnderlined',
          ['enum']                       = 'Type',
          ['delegate']                   = 'Type',
          ['variable']                   = 'Identifier',
          ['parameter']                  = '@parameter',
          ['property']                   = 'Identifier',
          ['field']                      = 'Identifier',
          ['keyword']                    = 'Keyword',
          ['controlKeyword']             = 'Keyword',
          ['constant']                   = 'Constant',
          ['enumMember']                 = 'Constant',
          ['regexGrouping']              = 'Special',
          ['namespace']                  = 'Namespace',
          ['string']                     = 'String',
          ['number']                     = 'Number',
          ['comment']                    = 'Comment',
          ['xmlDocComment']              = 'Comment',
          ['xmlDocCommentName']          = 'Comment',
          ['xmlDocCommentDelimiter']     = 'Comment',
          ['xmlDocCommentAttributeName'] = 'Comment',
          ['xmlDocCommentAttribute']     = 'Comment',
          ['xmlDocCommentText']          = 'Comment',
        }

        for token_type, hl_group in pairs(token_mappings) do
          vim.api.nvim_set_hl(0, '@lsp.type.' .. token_type, { link = hl_group })
        end
      end,
    })
  end,
}
