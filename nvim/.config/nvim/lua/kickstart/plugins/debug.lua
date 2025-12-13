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
