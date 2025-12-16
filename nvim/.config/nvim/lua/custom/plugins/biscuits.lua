return {
  'code-biscuits/nvim-biscuits',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
  },
  opts = {},
  keys = {
    {
      '<leader>n',
      function()
        local nvim_biscuits = require 'nvim-biscuits'
        nvim_biscuits.BufferAttach()
        nvim_biscuits.toggle_biscuits()
      end,
      mode = 'n',
      desc = 'Toggle Biscuits',
    },
  },
}
