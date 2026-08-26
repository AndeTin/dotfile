local M = {}

local path = vim.fn.expand('~/.local/state/omarchy/current/theme/colors.toml')

local fallback = {
  bg = '#2d353b',
  dark_bg = '#272e33',
  darker_bg = '#1e2326',
  lighter_bg = '#3d484d',
  fg = '#d3c6aa',
  dark_fg = '#a7c080',
  light_fg = '#e6d8b4',
  bright_fg = '#dbbc7f',
  muted = '#859289',
  red = '#e67e80',
  yellow = '#dbbc7f',
  orange = '#e69875',
  green = '#a7c080',
  cyan = '#83c092',
  blue = '#7fbbb3',
  magenta = '#d699b6',
  brown = '#d3c6aa',
  bright_red = '#e67e80',
  bright_yellow = '#dbbc7f',
  bright_green = '#a7c080',
  bright_cyan = '#83c092',
  bright_blue = '#7fbbb3',
  bright_magenta = '#d699b6',
  accent = '#a7c080',
  cursor = '#dbbc7f',
  foreground = '#d3c6aa',
  background = '#2d353b',
  selection = '#3d484d',
  selection_foreground = '#dbbc7f',
  selection_background = '#3d484d',
}

function M.load()
  local file = io.open(path, 'r')
  if not file then
    vim.notify('Omarchy theme not found, using everforest fallback', vim.log.levels.WARN)
    return fallback
  end

  local colors = {}
  for line in file:lines() do
    local k, v = line:match('^(%w+)%s*=%s*"([^"]+)"')
    if not k then
      k, v = line:match("^(%w+)%s*=%s*'([^']+)'")
    end
    if not k then
      k, v = line:match('^(%w+)%s*=%s*([%w#]+)')
    end
    if k and v then
      colors[k] = v
    end
  end
  file:close()

  if not colors.background then
    vim.notify('Omarchy theme parsing failed, using fallback', vim.log.levels.WARN)
    return fallback
  end

  return {
    bg = colors.background,
    dark_bg = colors.dark_background,
    darker_bg = colors.darker_background,
    lighter_bg = colors.lighter_background,
    fg = colors.foreground,
    dark_fg = colors.dark_foreground,
    light_fg = colors.light_foreground,
    bright_fg = colors.bright_foreground,
    muted = colors.muted,
    red = colors.red,
    yellow = colors.yellow,
    orange = colors.orange,
    green = colors.green,
    cyan = colors.cyan,
    blue = colors.blue,
    magenta = colors.magenta,
    brown = colors.brown,
    bright_red = colors.bright_red,
    bright_yellow = colors.bright_yellow,
    bright_green = colors.bright_green,
    bright_cyan = colors.bright_cyan,
    bright_blue = colors.bright_blue,
    bright_magenta = colors.bright_magenta,
    accent = colors.accent,
    cursor = colors.bright_foreground,
    foreground = colors.foreground,
    background = colors.background,
    selection = colors.selection,
    selection_foreground = colors.bright_foreground,
    selection_background = colors.selection,
  }
end

return M.load()