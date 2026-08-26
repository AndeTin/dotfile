return {
  'bjarneo/aether.nvim',
  branch = 'v3',
  name = 'aether',
  priority = 1000,
  lazy = false,
  config = function()
    local colors = require('omarchy-theme.colors')
    require('aether').setup({ colors = colors })
    vim.cmd.colorscheme('aether')
  end,
}