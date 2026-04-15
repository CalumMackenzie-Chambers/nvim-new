-- :checkhealth vb_ls
--
-- Proactive diagnostic for the VB.NET / vb-ls toolchain on Windows. Verifies
-- every piece the LSP needs, from the binary itself up through the MSBuild
-- version that Roslyn's BuildHost will end up loading. Also flags the
-- VS-18-alongside-BuildTools situation that necessitates our VSCMD_VER hack.
--
-- Run: `:checkhealth vb_ls`

local M = {}

local h = vim.health

local function trim(s) return (s or ''):gsub('^%s+', ''):gsub('%s+$', '') end

--- Run a command and return (stdout, ok).
local function run(cmd)
  local out = vim.fn.system(cmd)
  return trim(out), vim.v.shell_error == 0
end

local function find_vswhere()
  local p = 'C:/Program Files (x86)/Microsoft Visual Studio/Installer/vswhere.exe'
  if vim.fn.executable(p) == 1 then return p end
  return nil
end

local function check_vb_ls_binary()
  if vim.fn.executable('vb-ls') ~= 1 then
    h.error('vb-ls not on PATH', {
      'Install: dotnet tool install -g vb-ls',
      'Ensure %USERPROFILE%\\.dotnet\\tools is on PATH',
    })
    return
  end
  local ver = run({ 'vb-ls', '--version' })
  h.ok('vb-ls: ' .. ver)
end

local function check_dotnet()
  if vim.fn.executable('dotnet') ~= 1 then
    h.error('dotnet CLI not on PATH', {
      'Install the .NET SDK: https://dotnet.microsoft.com/download',
    })
    return
  end
  local sdks = run({ 'dotnet', '--list-sdks' })
  local runtimes = run({ 'dotnet', '--list-runtimes' })

  -- vb-ls 0.3.0 targets net9.0, so the .NET 9 RUNTIME must be present.
  if runtimes:match('Microsoft%.NETCore%.App 9%.') then
    h.ok('.NET 9 runtime installed (required by vb-ls 0.3.0)')
  else
    h.error('.NET 9 runtime missing — vb-ls 0.3.0 targets net9.0 and will fail to start', {
      'winget install Microsoft.DotNet.Runtime.9',
      'OR install the .NET 9 SDK which bundles the runtime',
    })
  end

  -- .NET 9 SDK useful for dotnet-SDK-style MSBuild and project build commands.
  if sdks:match('^9%.') or sdks:match('\n9%.') then
    h.ok('.NET 9 SDK installed')
  else
    h.warn('.NET 9 SDK not installed — only the runtime is required, SDK is nice-to-have')
  end
end

local function check_dotnet_tools_path()
  local sep = package.config:sub(1, 1)
  local tools_dir = vim.fn.expand('~/.dotnet/tools'):gsub('/', sep)
  if tools_dir == '' then return end
  local path = vim.env.PATH or ''
  -- Normalise slashes for comparison
  if path:lower():gsub('/', '\\'):find(tools_dir:lower():gsub('/', '\\'), 1, true) then
    h.ok('%USERPROFILE%\\.dotnet\\tools is on PATH')
  else
    h.warn(('%s is NOT on PATH — vb-ls may not be found'):format(tools_dir), {
      'Add it to your user PATH environment variable',
    })
  end
end

local function check_vswhere()
  local vswhere = find_vswhere()
  if not vswhere then
    h.error('vswhere.exe not found at ' ..
      'C:/Program Files (x86)/Microsoft Visual Studio/Installer/vswhere.exe', {
      'Install Visual Studio Installer (ships with any VS or Build Tools install)',
    })
    return nil
  end
  h.ok('vswhere: ' .. vswhere)
  return vswhere
end

local function check_buildtools_and_msbuild(vswhere)
  if not vswhere then return end

  local bt = run({
    vswhere,
    '-products', 'Microsoft.VisualStudio.Product.BuildTools',
    '-latest',
    '-property', 'installationPath',
  })
  if bt == '' then
    h.error('VS 2022 Build Tools not installed', {
      'winget install --id Microsoft.VisualStudio.2022.BuildTools ' ..
        '--override "--quiet --wait --norestart --nocache ' ..
        '--add Microsoft.VisualStudio.Workload.WebBuildTools ' ..
        '--add Microsoft.VisualStudio.Workload.ManagedDesktopBuildTools ' ..
        '--add Microsoft.NetFramework.Component.4.8.TargetingPack ' ..
        '--add Microsoft.Net.Component.4.8.SDK --includeRecommended"',
    })
    return
  end

  local bt_path = bt:gsub('\\', '/')
  h.ok('VS 2022 Build Tools: ' .. bt_path)

  local msbuild = bt_path .. '/MSBuild/Current/Bin/MSBuild.exe'
  if vim.fn.executable(msbuild) ~= 1 then
    h.error('MSBuild.exe missing at ' .. msbuild)
    return
  end

  local ver = run({ msbuild, '-version', '-nologo' })
  local major = tonumber(ver:match('(%d+)%.'))
  if not major then
    h.warn('Could not parse MSBuild version: ' .. ver)
  elseif major == 17 then
    h.ok('MSBuild ' .. ver .. ' (17.x — ideal for Roslyn BuildHost)')
  elseif major == 16 or major == 15 then
    h.ok('MSBuild ' .. ver .. ' (older but compatible with Roslyn BuildHost)')
  elseif major >= 18 then
    h.warn('MSBuild ' .. ver .. ' in Build Tools — newer than Roslyn BuildHost expects', {
      'BuildHost-net472 is built against MSBuild 17.x; 18+ may crash with XMakeElements',
      'The lsp/vb_ls.lua config already injects a DevConsole instance via VSCMD_VER=99.99.99',
    })
  else
    h.warn('MSBuild ' .. ver .. ' (<15, likely too old for Roslyn BuildHost)')
  end

  -- WebApplication.targets is what lets WebForms .vbproj files load.
  local web_targets = bt_path ..
    '/MSBuild/Microsoft/VisualStudio/v17.0/WebApplications/Microsoft.WebApplication.targets'
  if vim.fn.filereadable(web_targets) == 1 then
    h.ok('Microsoft.WebApplication.targets found (classic WebForms can be loaded)')
  else
    h.warn('Microsoft.WebApplication.targets missing — classic WebForms .vbproj will fail', {
      'Re-run the BuildTools installer with --add Microsoft.VisualStudio.Workload.WebBuildTools',
    })
  end

  -- .NET Framework targeting packs (required to compile 4.x projects).
  local any_netfx_pack = false
  for _, v in ipairs({ '4.8', '4.7.2', '4.7.1', '4.7', '4.6.2', '4.6.1', '4.6', '4.5.2' }) do
    local p = 'C:/Program Files (x86)/Reference Assemblies/Microsoft/Framework/.NETFramework/v' .. v
    if vim.fn.isdirectory(p) == 1 then
      h.ok('.NET Framework ' .. v .. ' targeting pack installed')
      any_netfx_pack = true
    end
  end
  if not any_netfx_pack then
    h.warn('No .NET Framework 4.x targeting packs found', {
      'Add: --add Microsoft.NetFramework.Component.4.8.TargetingPack',
    })
  end
end

local function check_vs_conflicts(vswhere)
  if not vswhere then return end

  -- If any VS install ≥18 is present, our VSCMD_VER=99.99.99 hack is
  -- actively doing work. Note that — on a clean machine, it's a no-op.
  local versions = run({ vswhere, '-products', '*', '-property', 'installationVersion' })
  local newer_found = false
  for line in versions:gmatch('[^\r\n]+') do
    local maj = tonumber(line:match('^(%d+)'))
    if maj and maj >= 18 then
      newer_found = true
      h.info(('VS %s installed alongside BuildTools — VSCMD_VER=99.99.99 override ' ..
              'in lsp/vb_ls.lua is the reason vb-ls works here'):format(line))
    end
  end
  if not newer_found then
    h.info('No VS >= 18 detected — VSCMD_VER override is a harmless no-op on this machine')
  end
end

function M.check()
  h.start('vb-ls toolchain')

  if vim.fn.has('win32') ~= 1 then
    h.info('Not running on Windows — vb-ls is Windows-only; skipping further checks')
    return
  end

  check_vb_ls_binary()
  check_dotnet()
  check_dotnet_tools_path()

  h.start('MSBuild / Visual Studio')

  local vswhere = check_vswhere()
  check_buildtools_and_msbuild(vswhere)
  check_vs_conflicts(vswhere)
end

return M
