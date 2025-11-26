return {
  'jiaoshijie/undotree',
  opts = {
    -- You can customize options here, or leave empty for defaults
    float_diff = true, -- use floating window for diff preview
    layout = 'left_bottom',
    position = 'left',
    window = {
      winblend = 30,
      border = 'rounded',
    },
    keymaps = {
      j = 'move_next',
      k = 'move_prev',
      gj = 'move2parent',
      J = 'move_change_next',
      K = 'move_change_prev',
      ['<cr>'] = 'action_enter',
      p = 'enter_diffbuf',
      q = 'quit',
    },
  },
  keys = {
    { '<leader>u', "<cmd>lua require('undotree').toggle()<cr>" },
  },
  config = function(_, opts)
    require('undotree').setup(opts)
    vim.keymap.set('n', '<leader>u', require('undotree').toggle, { noremap = true, silent = true, desc = 'Toggle Undotree' })
  end,
}
