return {
  'inhesrom/remote-ssh.nvim',
  dependencies = {
    'neovim/nvim-lspconfig', -- Required for LSP configuration
    'nvim-telescope/telescope.nvim', -- Dependency for some remote buffer telescope actions
    'nvim-lua/plenary.nvim',
  },
  config = function()
    require('remote-ssh').setup {
      -- Optional: Custom on_attach function for LSP clients
      on_attach = function(client, bufnr)
        -- Your LSP keybindings and setup
      end,

      -- Optional: Custom capabilities for LSP clients
      capabilities = vim.lsp.protocol.make_client_capabilities(),

      -- Custom mapping from filetype to LSP server name
      filetype_to_server = {
        -- Example: Use pylsp for Python (default and recommended)
        python = 'pylsp',
        -- More customizations...
      },

      -- Custom server configurations
      server_configs = {
        -- Custom config for clangd
        clangd = {
          filetypes = { 'c', 'cpp', 'objc', 'objcpp' },
          root_patterns = { '.git', 'compile_commands.json' },
          init_options = {
            usePlaceholders = true,
            completeUnimported = true,
          },
        },
        -- More server configs...
      },

      -- Async write configuration
      async_write_opts = {
        timeout = 30, -- Timeout in seconds for write operations
        debug = false, -- Enable debug logging
        log_level = vim.log.levels.INFO,
      },
    }
  end,
}
