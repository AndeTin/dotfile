return {
  'linux-cultist/venv-selector.nvim',
  dependencies = { 'nvim-telescope/telescope.nvim', 'nvim-lua/plenary.nvim' },
  ft = 'python',
  keys = {
    { '<leader>vs', '<cmd>VenvSelect<cr>', desc = '[V]env [S]elect' },
  },
  opts = {
    options = {},
    search = {},
  },
}