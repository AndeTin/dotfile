-- debug.luadebu
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

return {
  -- NOTE: Yes, you can install new plugins here!
  'mfussenegger/nvim-dap',
  -- NOTE: And you can specify dependencies as well
  dependencies = {
    -- Creates a beautiful debugger UI
    'rcarriga/nvim-dap-ui',

    -- Required dependency for nvim-dap-ui
    'nvim-neotest/nvim-nio',

    -- Installs the debug adapters for you
    'mason-org/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    -- Add your own debuggers here
    'leoluz/nvim-dap-go',
    'sakhnik/nvim-gdb',
    'julianolf/nvim-dap-lldb',
  },
  keys = {
    -- Basic debugging keymaps, feel free to change to your liking!
    {
      '<F5>',
      function()
        require('dap').continue()
      end,
      desc = 'Debug: Start/Continue',
    },
    {
      '<F1>',
      function()
        require('dap').step_into()
      end,
      desc = 'Debug: Step Into',
    },
    {
      '<F2>',
      function()
        require('dap').step_over()
      end,
      desc = 'Debug: Step Over',
    },
    {
      '<F3>',
      function()
        require('dap').step_out()
      end,
      desc = 'Debug: Step Out',
    },
    {
      '<leader>b',
      function()
        require('dap').toggle_breakpoint()
      end,
      desc = 'Debug: Toggle Breakpoint',
    },
    {
      '<leader>B',
      function()
        require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
      end,
      desc = 'Debug: Set Breakpoint',
    },
    -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
    {
      '<F7>',
      function()
        require('dapui').toggle()
      end,
      desc = 'Debug: See last session result.',
    },
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require('mason-nvim-dap').setup {
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_installation = true,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
        'delve',
        'codelldb',
        'gdb',
      },
    }

    local mason_registry = require 'mason-registry'

    local function codelldb_paths()
      local ok, pkg = pcall(mason_registry.get_package, 'codelldb')
      if not ok or not pkg then
        return nil
      end
      if type(pkg.is_installed) ~= 'function' or type(pkg.get_install_path) ~= 'function' then
        return nil
      end
      if not pkg:is_installed() then
        return nil
      end

      local extension_path = pkg:get_install_path() .. '/extension/'
      local codelldb = extension_path .. 'adapter/codelldb'
      local liblldb = extension_path .. 'lldb/lib/liblldb.so'

      local os = vim.loop.os_uname().sysname
      if os == 'Darwin' then
        liblldb = extension_path .. 'lldb/lib/liblldb.dylib'
      elseif os:find 'Windows' then
        codelldb = codelldb .. '.exe'
        liblldb = extension_path .. 'lldb/bin/liblldb.dll'
      end

      return codelldb, liblldb
    end

    local codelldb_path, liblldb_path = codelldb_paths()

    if codelldb_path then
      dap.adapters.codelldb = {
        type = 'server',
        port = '${port}',
        executable = {
          command = codelldb_path,
          args = { '--liblldb', liblldb_path, '--port', '${port}' },
        },
      }
    else
      dap.adapters.codelldb = {
        type = 'server',
        port = '${port}',
        executable = {
          command = 'codelldb',
          args = { '--port', '${port}' },
        },
      }
    end

    if vim.fn.executable 'gdb' == 1 then
      dap.adapters.gdb = {
        type = 'executable',
        command = 'gdb',
        args = { '--quiet', '--interpreter=dap' },
      }
    end

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    dapui.setup {
      -- Set icons to characters that are more likely to work in every terminal.
      --    Feel free to remove or use ones that you like more! :)
      --    Don't feel like these are good choices.
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
    }

    -- Change breakpoint icons
    -- vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#e51400' })
    -- vim.api.nvim_set_hl(0, 'DapStop', { fg = '#ffcc00' })
    -- local breakpoint_icons = vim.g.have_nerd_font
    --     and { Breakpoint = '', BreakpointCondition = '', BreakpointRejected = '', LogPoint = '', Stopped = '' }
    --   or { Breakpoint = '●', BreakpointCondition = '⊜', BreakpointRejected = '⊘', LogPoint = '◆', Stopped = '⭔' }
    -- for type, icon in pairs(breakpoint_icons) do
    --   local tp = 'Dap' .. type
    --   local hl = (type == 'Stopped') and 'DapStop' or 'DapBreak'
    --   vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
    -- end

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    -- Install golang specific config
    require('dap-go').setup {
      delve = {
        -- On Windows delve must be run attached or it crashes.
        -- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
        detached = vim.fn.has 'win32' == 0,
      },
    }
    -- Set up C-family debugger configurations
    local function select_program()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end

    local function choose_adapter()
      return dap.adapters.gdb and 'gdb' or 'codelldb'
    end

    local function ensure_build_directory()
      local dir = vim.fn.stdpath 'data' .. '/dap_builds'
      if vim.fn.isdirectory(dir) == 0 then
        vim.fn.mkdir(dir, 'p')
      end
      return dir
    end

    local function build_current_buffer(opts)
      local file = vim.api.nvim_buf_get_name(0)
      if file == '' then
        vim.notify('Current buffer has no file on disk.', vim.log.levels.ERROR, { title = opts.name })
        return nil
      end

      if vim.bo.modified then
        local ok, err = pcall(vim.cmd.write)
        if not ok then
          vim.notify('Unable to save buffer before building: ' .. err, vim.log.levels.ERROR, { title = opts.name })
          return nil
        end
      end

      local build_dir = ensure_build_directory()
      local output = build_dir .. '/' .. vim.fn.fnamemodify(file, ':t:r')
      if vim.loop.os_uname().sysname:find 'Windows' then
        output = output .. '.exe'
      end

      local command = opts.command(file, output)
      local result = vim.fn.systemlist(command)

      if vim.v.shell_error ~= 0 then
        if #result == 0 then
          result = { 'Build command failed: ' .. command }
        end
        vim.notify(table.concat(result, '\n'), vim.log.levels.ERROR, { title = opts.name })
        return nil
      end

      if opts.on_success then
        opts.on_success(command, result, output)
      elseif #result > 0 then
        vim.notify(table.concat(result, '\n'), vim.log.levels.INFO, { title = opts.name })
      else
        vim.notify(('Built %s'):format(output), vim.log.levels.INFO, { title = opts.name })
      end

      return output
    end

    local function shellescape(path)
      return vim.fn.shellescape(path)
    end

    local function find_cargo_manifest(start_path)
      local matches = vim.fs.find('Cargo.toml', { path = start_path, upward = true })
      if #matches == 0 then
        return nil
      end
      return vim.fn.fnamemodify(matches[1], ':p')
    end

    local function cargo_metadata(manifest_path, title)
      local cmd = { 'cargo', 'metadata', '--no-deps', '--format-version', '1', '--manifest-path', manifest_path }
      local result = vim.fn.systemlist(cmd)

      if vim.v.shell_error ~= 0 then
        if #result == 0 then
          result = { 'cargo metadata failed with exit code ' .. vim.v.shell_error }
        end
        vim.notify(table.concat(result, '\n'), vim.log.levels.ERROR, { title = title })
        return nil
      end

      local ok, metadata = pcall(vim.json.decode, table.concat(result, '\n'))
      if not ok then
        vim.notify('Unable to parse cargo metadata output.', vim.log.levels.ERROR, { title = title })
        return nil
      end

      return metadata
    end

    local function cargo_package_for_manifest(metadata, manifest_path)
      manifest_path = vim.fn.fnamemodify(manifest_path, ':p')
      for _, pkg in ipairs(metadata.packages or {}) do
        if vim.fn.fnamemodify(pkg.manifest_path or '', ':p') == manifest_path then
          return pkg
        end
      end
      return metadata.packages and metadata.packages[1] or nil
    end

    local function cargo_bin_targets(pkg)
      local targets = {}
      for _, target in ipairs(pkg.targets or {}) do
        if vim.tbl_contains(target.kind or {}, 'bin') then
          table.insert(targets, target.name)
        end
      end
      return targets
    end

    local function select_rust_binary_target(name, pkg, targets)
      if #targets == 0 then
        vim.notify(('No binary targets found in %s.'):format(pkg.name or 'package'), vim.log.levels.ERROR, { title = name })
        return nil
      end
      if #targets == 1 then
        return targets[1]
      end

      local prompt = { ('Select binary target for %s:'):format(pkg.name or 'package') }
      for idx, target in ipairs(targets) do
        table.insert(prompt, string.format('%d. %s', idx, target))
      end

      local choice = vim.fn.inputlist(prompt)
      if choice < 1 or choice > #targets then
        vim.notify('Canceled target selection.', vim.log.levels.WARN, { title = name })
        return nil
      end

      return targets[choice]
    end

    local function build_rust_executable(params)
      if vim.fn.executable('cargo') ~= 1 then
        vim.notify('Cargo executable not found in PATH.', vim.log.levels.ERROR, { title = params.name })
        return nil
      end

      local file = vim.api.nvim_buf_get_name(0)
      if file == '' then
        vim.notify('Current buffer has no file on disk.', vim.log.levels.ERROR, { title = params.name })
        return nil
      end

      if vim.bo.modified then
        local ok, err = pcall(vim.cmd.write)
        if not ok then
          vim.notify('Unable to save buffer before building: ' .. err, vim.log.levels.ERROR, { title = params.name })
          return nil
        end
      end

      local manifest = find_cargo_manifest(vim.fn.fnamemodify(file, ':p:h'))
      if not manifest then
        vim.notify('Could not locate Cargo.toml for the current buffer.', vim.log.levels.ERROR, { title = params.name })
        return nil
      end

      local metadata = cargo_metadata(manifest, params.name)
      if not metadata then
        return nil
      end

      local pkg = cargo_package_for_manifest(metadata, manifest)
      if not pkg then
        vim.notify('Unable to determine Cargo package for manifest.', vim.log.levels.ERROR, { title = params.name })
        return nil
      end

      local targets = cargo_bin_targets(pkg)
      local target_name = select_rust_binary_target(params.name, pkg, targets)
      if not target_name then
        return nil
      end

      local cmd = { 'cargo', 'build', '--manifest-path', manifest }
      if params.release then
        table.insert(cmd, '--release')
      end
      table.insert(cmd, '--bin')
      table.insert(cmd, target_name)

      local result = vim.fn.systemlist(cmd)
      if vim.v.shell_error ~= 0 then
        if #result == 0 then
          result = { 'cargo build failed with exit code ' .. vim.v.shell_error }
        end
        vim.notify(table.concat(result, '\n'), vim.log.levels.ERROR, { title = params.name })
        return nil
      end

      if #result > 0 then
        vim.notify(table.concat(result, '\n'), vim.log.levels.INFO, { title = params.name })
      else
        vim.notify('cargo build completed successfully.', vim.log.levels.INFO, { title = params.name })
      end

      local profile_dir = params.release and 'release' or 'debug'
      local exe = metadata.target_directory .. '/' .. profile_dir .. '/' .. target_name
      if vim.loop.os_uname().sysname:find 'Windows' then
        exe = exe .. '.exe'
      end

      if vim.loop.fs_stat(exe) then
        return exe
      end

      vim.notify(('Built binary not found at %s. Please select manually.'):format(exe), vim.log.levels.WARN, { title = params.name })
      return select_program()
    end

    local function default_command(compiler, standard, extra_flags)
      return function(src, exe)
        local parts = { vim.fn.shellescape(compiler), '-g', '-O0' }
        if standard and #standard > 0 then
          table.insert(parts, standard)
        end
        if extra_flags then
          for _, flag in ipairs(extra_flags) do
            table.insert(parts, flag)
          end
        end
        table.insert(parts, shellescape(src))
        table.insert(parts, '-o')
        table.insert(parts, shellescape(exe))
        return table.concat(parts, ' ')
      end
    end

    local function create_build_config(params)
      if params.compiler and vim.fn.executable(params.compiler) ~= 1 then
        return nil
      end
      if params.adapter and not dap.adapters[params.adapter] then
        return nil
      end

      local command_builder = params.command or default_command(params.compiler, params.standard, params.extra_flags)

      return {
        name = params.name,
        type = params.adapter or choose_adapter(),
        request = 'launch',
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        args = params.args,
        program = function()
          return build_current_buffer {
            name = params.name,
            command = function(src, exe)
              return command_builder(src, exe, params)
            end,
            on_success = params.on_success,
          }
        end,
      }
    end

    local base_configs = {
      {
        name = 'Launch executable',
        type = choose_adapter(),
        request = 'launch',
        program = select_program,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
      },
      {
        name = 'Attach to process',
        type = choose_adapter(),
        request = 'attach',
        pid = require('dap.utils').pick_process,
        cwd = '${workspaceFolder}',
      },
    }

    local c_configs = vim.deepcopy(base_configs)
    local cpp_configs = vim.deepcopy(base_configs)
    local rust_configs = vim.deepcopy(base_configs)

    local function add_rust_config(opts)
      if not dap.adapters.codelldb then
        return
      end
      table.insert(rust_configs, {
        name = opts.name,
        type = 'codelldb',
        request = 'launch',
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        program = function()
          return build_rust_executable(opts)
        end,
      })
    end

    add_rust_config {
      name = 'Cargo build & debug',
    }

    add_rust_config {
      name = 'Cargo build & debug (release)',
      release = true,
    }

    local clang_c = create_build_config {


      name = 'Build & Debug (clang)',
      compiler = 'clang',
      adapter = 'codelldb',
      standard = '-std=c17',
      extra_flags = { '-Wall', '-Wextra' },
    }
    if clang_c then
      table.insert(c_configs, clang_c)
    end

    local gcc_c = create_build_config {
      name = 'Build & Debug (gcc + gdb)',
      compiler = 'gcc',
      adapter = 'gdb',
      extra_flags = { '-Wall', '-Wextra' },
    }
    if gcc_c then
      table.insert(c_configs, gcc_c)
    end

    local clang_cpp = create_build_config {
      name = 'Build & Debug (clang++)',
      compiler = 'clang++',
      adapter = 'codelldb',
      standard = '-std=c++20',
      extra_flags = { '-Wall', '-Wextra' },
    }
    if clang_cpp then
      table.insert(cpp_configs, clang_cpp)
    end

    local gpp_cpp = create_build_config {
      name = 'Build & Debug (g++ + gdb)',
      compiler = 'g++',
      adapter = 'gdb',
      standard = '-std=c++20',
      extra_flags = { '-Wall', '-Wextra' },
    }
    if gpp_cpp then
      table.insert(cpp_configs, gpp_cpp)
    end

    dap.configurations.c = c_configs
    dap.configurations.cpp = cpp_configs
    dap.configurations.rust = rust_configs
  end,
}
