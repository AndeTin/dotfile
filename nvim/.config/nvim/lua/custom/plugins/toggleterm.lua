return {
  'akinsho/toggleterm.nvim',
  version = '*',
  config = function()
    require('toggleterm').setup {
      size = 20,
      open_mapping = [[<leader>p]],
      direction = 'float',
      float_opts = {
        border = 'curved',
        winblend = 3,
      },
      shade_terminals = true,
      start_in_insert = true,
      persist_mode = true,
    }
  end,
}
