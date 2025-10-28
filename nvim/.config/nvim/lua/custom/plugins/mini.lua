return {
  'echasnovski/mini.nvim',
  config = function()
    -- mini.ai
    require('mini.ai').setup { n_lines = 500 }

    -- mini.surround
    require('mini.surround').setup {
      mappings = {
        add = 'sa',
        delete = 'sd',
        find = 'sf',
        find_left = 'sF',
        highlight = 'sh',
        replace = 'sr',
        suffix_last = 'l',
        suffix_next = 'n',
      },
    }
    -- Explicitly override default 's' in normal mode to use mini.surround
    vim.keymap.set('n', 's', function()
      MiniSurround.add 'n'
    end, { desc = 'MiniSurround add (override substitute)' })

    -- mini.statusline
    local statusline = require 'mini.statusline'
    statusline.setup { use_icons = vim.g.have_nerd_font }
    statusline.section_location = function()
      return '%2l:%-2v'
    end
  end,
}
