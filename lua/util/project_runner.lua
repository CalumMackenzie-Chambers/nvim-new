local M = {}

local function find_project_root()
  local markers = { '.git', '.neovim', 'package.json', '*.sln', 'Cargo.toml', 'pyproject.toml' }
  return vim.fs.root(0, markers)
end

local function load_run_config()
  local project_root = find_project_root()
  if not project_root then
    return nil
  end

  local config_path = project_root .. '/.neovim/run.json'
  local file = io.open(config_path, 'r')
  if not file then
    return nil
  end

  local content = file:read('*all')
  file:close()

  local ok, config = pcall(vim.json.decode, content)
  if not ok then
    vim.notify('Error parsing .neovim/run.json: ' .. config, vim.log.levels.ERROR)
    return nil
  end

  return config, project_root
end

local function handle_command_output(output_file, error_format)
  if not vim.fn.filereadable(output_file) then
    return
  end

  local errors = {}
  local efm = error_format or "%f(%l\\,%c): %m" -- Default .NET format

  for line in io.lines(output_file) do
    if line:match("error") or line:match("Error") or line:match("ERROR") then
      table.insert(errors, line)
    end
  end

  if #errors > 0 then
    vim.fn.setqflist({}, " ", {
      title = "Command Errors",
      lines = errors,
      efm = efm,
    })
    vim.cmd("copen")
  end
end

local function execute_command(command_config, project_root)
  if vim.api.nvim_get_option_value("modifiable", { buf = 0 }) and vim.bo.modified then
    pcall(function() vim.cmd("w") end)
  end

  local cmd = command_config.command
  local output_file = command_config.output_file
  local error_format = command_config.error_format
  local cwd = command_config.cwd and (project_root .. '/' .. command_config.cwd) or project_root

  if output_file then
    if not output_file:match("^/") and not output_file:match("^%a:") then

      output_file = project_root .. '/' .. output_file
    end
    cmd = cmd .. ' > "' .. output_file .. '" 2>&1'
  end

  vim.notify('Running: ' .. command_config.name)
  vim.cmd('redraw!')

  vim.fn.jobstart(cmd, {
    cwd = cwd,
    on_exit = function(_, return_val, _)
      if return_val == 0 then
        vim.notify('Command completed successfully: ' .. command_config.name)
        if output_file then
          handle_command_output(output_file, error_format)
        end
      else
        vim.notify('Command failed: ' .. command_config.name, vim.log.levels.WARN)
        if output_file then
          handle_command_output(output_file, error_format)
        end
      end
      vim.cmd('redraw!')
    end,
  })
end

function M.show_run_menu()
  local config, project_root = load_run_config()
  if not config or not config.commands then
    vim.notify('No .neovim/run.json found or no commands defined', vim.log.levels.WARN)
    return
  end

  local commands = config.commands
  local default_command = config.default

  vim.ui.select(commands, {
    prompt = "Select command to run:",
    format_item = function(item)
      local marker = (default_command and item.key == default_command) and " (default)" or ""
      return item.name .. marker
    end,
  }, function(choice)
    if choice then
      execute_command(choice, project_root)
    end
  end)
end

function M.run_default()
  local config, project_root = load_run_config()
  if not config or not config.commands or not config.default then
    vim.notify('No default command defined', vim.log.levels.WARN)
    return
  end

  local default_cmd = nil
  for _, cmd in ipairs(config.commands) do
    if cmd.key == config.default then
      default_cmd = cmd
      break
    end
  end

  if default_cmd then
    execute_command(default_cmd, project_root)
  else
    vim.notify('Default command not found', vim.log.levels.ERROR)
  end
end

function M.create_example_config()
  local project_root = find_project_root()
  if not project_root then
    vim.notify('No project root found', vim.log.levels.ERROR)
    return
  end

  local neovim_dir = project_root .. '/.neovim'
  vim.fn.mkdir(neovim_dir, 'p')

  local example_config = {
    default = "dev_build",
    commands = {
      {
        key = "dev_build",
        name = "Development Build",
        command = 'msbuild "path/to/solution.sln" /p:Configuration="Debug"',
        output_file = "build_output.txt",
        error_format = "%f(%l\\,%c): %m",
        cwd = "."
      },
      {
        key = "release_build",
        name = "Release Build",
        command = 'msbuild "path/to/solution.sln" /p:Configuration="Release"',
        output_file = "build_output.txt",
        error_format = "%f(%l\\,%c): %m"
      },
      {
        key = "test",
        name = "Run Tests",
        command = "dotnet test",
        output_file = "test_output.txt"
      }
    }
  }

  local config_file = neovim_dir .. '/run.json'
  local file = io.open(config_file, 'w')
  if file then
    file:write(vim.json.encode(example_config))
    file:close()
    vim.notify('Created example .neovim/run.json at ' .. config_file)
    vim.cmd('edit ' .. config_file)
  else
    vim.notify('Failed to create config file', vim.log.levels.ERROR)
  end
end

return M
