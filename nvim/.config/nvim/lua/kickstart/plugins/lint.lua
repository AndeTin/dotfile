return {

  { -- Linting
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require 'lint'
lint.linters_by_ft = {
		 markdown = { 'markdownlint' },
		 c = { 'cpplint' },
		 cpp = { 'cpplint' },
		 python = { 'flake8', 'mypy' },
		 rust = { 'clippy' },
		 javascript = { 'eslint_d' },
		 typescript = { 'eslint_d' },
		 kotlin = { 'ktlint' },
		 vue = { 'eslint_d' },
		 }

      -- Always pass --filter=-legal/copyright to cpplint
      lint.linters.cpplint = {
        cmd = 'cpplint',
        stdin = false,
        args = { '--filter=-legal/copyright,-whitespace/indent' },
        stream = 'stderr',
        ignore_exitcode = true,
        parser = require('lint.parser').from_pattern(
          [[(%S+):(%d+):  (.*)]],
          { 'file', 'lnum', 'message' },
          nil,
          { ['severity'] = vim.diagnostic.severity.WARN }
        ),
      }

      -- To allow other plugins to add linters to require('lint').linters_by_ft,
      -- instead set linters_by_ft like this:
      -- lint.linters_by_ft = lint.linters_by_ft or {}
      -- lint.linters_by_ft['markdown'] = { 'markdownlint' }
      --
      -- However, note that this will enable a set of default linters,
      -- which will cause errors unless these tools are available:
      -- {
      --   clojure = { "clj-kondo" },
      --   dockerfile = { "hadolint" },
      --   inko = { "inko" },
      --   janet = { "janet" },
      --   json = { "jsonlint" },
      --   markdown = { "vale" },
      --   rst = { "vale" },
      --   ruby = { "ruby" },
      --   terraform = { "tflint" },
      --   text = { "vale" }
      -- }
      --
      -- You can disable the default linters by setting their filetypes to nil:
      -- lint.linters_by_ft['clojure'] = nil
      -- lint.linters_by_ft['dockerfile'] = nil
      -- lint.linters_by_ft['inko'] = nil
      -- lint.linters_by_ft['janet'] = nil
      -- lint.linters_by_ft['json'] = nil
      -- lint.linters_by_ft['markdown'] = nil
      -- lint.linters_by_ft['rst'] = nil
      -- lint.linters_by_ft['ruby'] = nil
      -- lint.linters_by_ft['terraform'] = nil
      -- lint.linters_by_ft['text'] = nil

      -- Diagnostics toggle state
      vim.g.diagnostics_enabled = true

      -- Toggle function
      function ToggleDiagnostics()
        vim.g.diagnostics_enabled = not vim.g.diagnostics_enabled
        if vim.g.diagnostics_enabled then
          vim.diagnostic.enable()
          print('Diagnostics enabled')
        else
          vim.diagnostic.enable(false)
          print('Diagnostics disabled')
        end
      end

      -- Key binding for <leader>.
      vim.keymap.set('n', '<leader>.', ToggleDiagnostics, { desc = '[T]oggle Diagnostics/Linter' })

      -- Create autocommand which carries out the actual linting
      -- on the specified events.
      local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = lint_augroup,
        callback = function()
          -- Only run the linter in buffers that you can modify in order to
          -- avoid superfluous noise, notably within the handy LSP pop-ups that
          -- describe the hovered symbol using Markdown.
          if vim.bo.modifiable and vim.g.diagnostics_enabled then
            lint.try_lint()
          else
            -- Optionally clear diagnostics when disabled
            vim.diagnostic.reset()
          end
        end,
      })
    end,
  },
}
