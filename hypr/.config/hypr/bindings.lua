-- ============================================================
-- Personal Omarchy 4 keybinding overrides
-- ============================================================

-- ------------------------------------------------------------
-- Terminal
-- ------------------------------------------------------------

-- Omarchy 4 uses SUPER + ALT + RETURN for Tmux.
-- Restore your old Kitty "alternate terminal" binding.
hl.unbind("SUPER + ALT + RETURN")
o.bind(
    "SUPER + ALT + RETURN",
    "Alternate Terminal",
    'uwsm-app -- kitty --working-directory="$(omarchy-cmd-terminal-cwd)"'
)


-- ------------------------------------------------------------
-- File managers
-- ------------------------------------------------------------

-- Omarchy 4: SUPER + SHIFT + F = File manager
-- Old config: Yazi
hl.unbind("SUPER + SHIFT + F")
o.bind(
    "SUPER + SHIFT + F",
    "Yazi",
    "omarchy-launch-tui yazi"
)

-- Omarchy 4 already has this binding, but points to its
-- file-manager/cwd behavior. Restore Nautilus.
hl.unbind("SUPER + SHIFT + ALT + F")
o.bind(
    "SUPER + SHIFT + ALT + F",
    "File manager",
    "uwsm-app -- nautilus --new-window"
)


-- ------------------------------------------------------------
-- Browsers
-- ------------------------------------------------------------

-- SUPER + SHIFT + B is already Browser in Omarchy 4.
-- No override needed.

-- SUPER + SHIFT + ALT + B
-- Omarchy 4 = private browser
-- Old config = Vivaldi
hl.unbind("SUPER + SHIFT + ALT + B")
o.bind(
    "SUPER + SHIFT + ALT + B",
    "Alt Browser",
    "uwsm-app -- vivaldi"
)


-- ------------------------------------------------------------
-- Multimedia / editors
-- ------------------------------------------------------------

-- Omarchy 4 already has SUPER + SHIFT + M = Music.
-- Keep the old exact Termusic command.
hl.unbind("SUPER + SHIFT + M")
o.bind(
    "SUPER + SHIFT + M",
    "Music",
    'uwsm-app -- xdg-terminal-exec --dir="$(omarchy-cmd-terminal-cwd)" termusic'
)

-- SUPER + SHIFT + N is already Editor.
-- No override needed.

-- Add old btop binding.
o.bind(
    "SUPER + SHIFT + T",
    "Activity",
    "omarchy-launch-tui btop"
)


-- ------------------------------------------------------------
-- Desktop applications
-- ------------------------------------------------------------

-- SUPER + SHIFT + D
-- Omarchy 4 = Docker
-- Old config = Discord
hl.unbind("SUPER + SHIFT + D")
o.bind(
    "SUPER + SHIFT + D",
    "Discord",
    "uwsm-app -- vesktop"
)

-- SUPER + SHIFT + S
-- Omarchy 4 = Google Maps
-- Old config = Steam
hl.unbind("SUPER + SHIFT + S")
o.bind(
    "SUPER + SHIFT + S",
    "Steam",
    "uwsm-app -- steam"
)

-- SUPER + SHIFT + E
-- Omarchy 4 = Email
-- Old config = Thunderbird
hl.unbind("SUPER + SHIFT + E")
o.bind(
    "SUPER + SHIFT + E",
    "Email",
    "uwsm-app -- thunderbird"
)

-- SUPER + SHIFT + /
-- Omarchy 4 already has Passwords.
-- Restore 1Password explicitly.
hl.unbind("SUPER + SHIFT + SLASH")
o.bind(
    "SUPER + SHIFT + SLASH",
    "Passwords",
    "uwsm-app -- 1password"
)


-- ------------------------------------------------------------
-- Web apps
-- ------------------------------------------------------------

-- SUPER + SHIFT + A = ChatGPT already.
-- Keep Omarchy 4 default.

-- SUPER + SHIFT + ALT + A
-- Omarchy 4 = Grok
-- Old config = Gemini
hl.unbind("SUPER + SHIFT + ALT + A")
o.bind(
    "SUPER + SHIFT + ALT + A",
    "Gemini",
    'omarchy-launch-webapp "https://gemini.google.com/app"'
)


-- ------------------------------------------------------------
-- Old Waybar restart binding
-- ------------------------------------------------------------

-- SUPER + SHIFT + R
--
-- Old Omarchy 3.x:
--   omarchy restart waybar
--
-- Omarchy 4 uses Quickshell rather than Waybar.
-- Do NOT migrate this old command.
--
-- Add a replacement here only if you specifically want a
-- Quickshell restart/reload shortcut.


-- ============================================================
-- Optional old bindings
-- ============================================================

-- Signal
-- o.bind(
--     "SUPER + SHIFT + G",
--     "Signal",
--     'omarchy-launch-or-focus ^signal$ "uwsm-app -- signal-desktop"'
-- )

-- Obsidian
-- o.bind(
--     "SUPER + SHIFT + O",
--     "Obsidian",
--     'omarchy-launch-or-focus ^obsidian$ "uwsm-app -- obsidian"'
-- )

-- Typora
-- o.bind(
--     "SUPER + SHIFT + W",
--     "Typora",
--     "uwsm-app -- typora --enable-wayland-ime"
-- )

-- Calendar
-- o.bind(
--     "SUPER + SHIFT + C",
--     "Calendar",
--     'omarchy-launch-webapp "https://app.hey.com/calendar/weeks/"'
-- )

-- YouTube
-- o.bind(
--     "SUPER + SHIFT + Y",
--     "YouTube",
--     'omarchy-launch-webapp "https://youtube.com/"'
-- )

-- WhatsApp
-- o.bind(
--     "SUPER + SHIFT + ALT + G",
--     "WhatsApp",
--     'omarchy-launch-or-focus-webapp WhatsApp "https://web.whatsapp.com/"'
-- )

-- Google Messages
-- o.bind(
--     "SUPER + SHIFT + CTRL + G",
--     "Google Messages",
--     'omarchy-launch-or-focus-webapp "Google Messages" "https://messages.google.com/web/conversations"'
-- )

-- Google Photos
-- o.bind(
--     "SUPER + SHIFT + P",
--     "Google Photos",
--     'omarchy-launch-or-focus-webapp "Google Photos" "https://photos.google.com/"'
-- )

-- X
-- o.bind(
--     "SUPER + SHIFT + X",
--     "X",
--     'omarchy-launch-webapp "https://x.com/"'
-- )

-- X Post
-- o.bind(
--     "SUPER + SHIFT + ALT + X",
--     "X Post",
--     'omarchy-launch-webapp "https://x.com/compose/post"'
-- )
