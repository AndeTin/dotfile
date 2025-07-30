return {
  'github/copilot.vim',
  lazy = false,
  config = function()
    -- Start with Copilot disabled
    vim.g.copilot_enabled_flag = false
    vim.cmd 'Copilot disable'

    -- Optional: Prevent Copilot from mapping <Tab>
    vim.g.copilot_no_tab_map = true
    vim.g.copilot_assume_mapped = true
    vim.g.copilot_tab_fallback = ''

    -- Function to toggle Copilot
    local function toggle_copilot()
      if vim.g.copilot_enabled_flag then
        vim.cmd 'Copilot disable'
        vim.g.copilot_enabled_flag = false
        vim.notify('Copilot disabled', vim.log.levels.INFO)
      else
        vim.cmd 'Copilot enable'
        vim.g.copilot_enabled_flag = true
        vim.notify('Copilot enabled', vim.log.levels.INFO)
      end
    end

    -- Create a user command and keymap for toggling
    vim.api.nvim_create_user_command('CopilotToggle', toggle_copilot, {})
    vim.keymap.set('n', '<leader>ct', '<cmd>CopilotToggle<CR>', { desc = 'Toggle Copilot' })
  end,
}
