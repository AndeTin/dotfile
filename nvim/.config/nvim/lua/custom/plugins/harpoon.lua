return {

  'ThePrimeagen/harpoon',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local mark = require 'harpoon.mark'
    local ui = require 'harpoon.ui'

    require('harpoon').setup()

    vim.keymap.set('n', '<leader>hr', mark.rm_file, { desc = 'Remove file from Harpoon' })
    vim.keymap.set('n', '<leader>ha', mark.add_file, { desc = 'Add file to Harpoon' })
    vim.keymap.set('n', '<leader>hm', ui.toggle_quick_menu, { desc = 'Toggle Harpoon menu' })
    vim.keymap.set('n', '<leader>h1', function()
      ui.nav_file(1)
    end, { desc = 'Navigate to Harpoon file 1' })
    vim.keymap.set('n', '<leader>h2', function()
      ui.nav_file(2)
    end, { desc = 'Navigate to Harpoon file 2' })
    vim.keymap.set('n', '<leader>h3', function()
      ui.nav_file(3)
    end, { desc = 'Navigate to Harpoon file 3' })
    vim.keymap.set('n', '<leader>h4', function()
      ui.nav_file(4)
    end, { desc = 'Navigate to Harpoon file 4' })
    vim.keymap.set('n', '<leader>h5', function()
      ui.nav_file(5)
    end, { desc = 'Navigate to Harpoon file 5' })
    vim.keymap.set('n', '<leader>h6', function()
      ui.nav_file(6)
    end, { desc = 'Navigate to Harpoon file 6' })
  end,
}
