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

-- Pharmica build commands
local function parse_build_errors()
  local build_output_file = vim.fn.expand("~/pharm_build.txt")
  local errors = {}
  local efm = "%f(%l\\,%c): %m"

  for line in io.lines(build_output_file) do
    if line:match("error [^:]*:") then
      table.insert(errors, line)
    end
  end

  if #errors > 0 then
    vim.fn.setqflist({}, " ", {
      title = "Build Errors",
      lines = errors,
      efm = efm,
    })
    vim.cmd("copen")
  else
    print("Build successful, no errors.")
  end
end

local function build(config, skip_node_npm_target)
  if vim.api.nvim_buf_get_option(0, "modifiable") and vim.bo.modified then
    pcall(vim.cmd, "w")
  end

  local build_output = vim.fn.expand("~/pharm_build.txt")
  local skip_node_npm = skip_node_npm_target and "/p:SkipNodeNpmTarget=true" or ""
  local build_cmd = 'msbuild "C:\\inetpub\\wwwroot\\eComV4\\eComV4.sln" /p:Configuration="'
      .. config
      .. '" '
      .. skip_node_npm
      .. " > "
      .. build_output
      .. " 2>&1"

  vim.cmd('silent! echo "Building project with configuration: ' .. config .. '..."')
  vim.cmd('redraw!')

  vim.fn.jobstart(build_cmd, {
    on_exit = function(j, return_val, event)
      if return_val == 0 then
        parse_build_errors()
      else
        vim.cmd('silent! echo "Build failed with errors. Check the quickfix list."')
        vim.cmd('redraw!')
        parse_build_errors()
      end
    end,
  })
end

local build_with_dev_config = function()
  build("Pharm Dev", true)
end
map("n", "<leader><leader>", "", { noremap = true, silent = true, callback = build_with_dev_config })

local function build_popup()
  local choices = {
    { label = "OneVit",  config = "OneVit",  skip_node_npm_target = true },
    { label = "Pharm Dev",  config = "Pharm Dev",  skip_node_npm_target = true },
    { label = "Pharm Live", config = "Pharm Live", skip_node_npm_target = true },
    { label = "Slow Dev",   config = "Pharm Dev",  skip_node_npm_target = false },
    { label = "Slow Live",  config = "Pharm Live", skip_node_npm_target = false },
  }

  local selected = false
  vim.ui.select(choices, {
    prompt = "Select Build Option:",
    format_item = function(item)
      return item.label
    end,
  }, function(choice)
    selected = true
    if choice then
      vim.cmd('redraw')
      build(choice.config, choice.skip_node_npm_target)
    end
  end)

  vim.defer_fn(function()
    if not selected then
      vim.cmd('redraw')
      build("Pharm Dev", true)
    end
  end, 1000)
end

map("n", "<leader><leader>", "", { noremap = true, silent = true, callback = build_popup })

local function close_iis_logs()
    vim.cmd('q')
end

vim.api.nvim_set_keymap('n', '<leader>pl', ':vsp<CR>:terminal pwsh -NoProfile -ExecutionPolicy Bypass -File "C:\\Users\\Calum\\Documents\\PowerShell\\Scripts\\attach_iis_logs.ps1"<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>pc', ':q<CR>', { noremap = true, silent = true })
