-- colour definitions (in line with one dark theme)
l_grey = 12563115
d_grey = 3419176
red = 7695584
green = 7979928
yellow = 8110309
blue = 15708001
purple = 14514374
aqua = 12760662
white = 16777215

-- font definitions
text_font = "IBM Plex Sans"
icon_font_1 = "Font Awesome 5 Free Solid"
icon_font_2 = "Font Awesome 5 Brands Regular"

local direction_keys = {
    Left = "left",
    Down = "down",
    Up = "up",
    Right = "right"
}

-- ===============================================================
--                      Bar components
-- ===============================================================
-- bar_worspaces --
bar_workspaces = function()
    return {
        name = "Workspaces",
        render = function(display_id)
            local ws_ids = nog.get_active_ws_of_display(display_id)
            local result = {}
            local factor

            for _, ws_id in ipairs(ws_ids) do
                table.insert(result, {
                    text = " " .. nog.get_ws_text(ws_id) .. " ",
                    fg = d_grey,
                    bg = nog.is_ws_focused(ws_id) and blue or l_grey
                })
            end

            return result
        end
    }
end

-- bar datetime --
local show_date = false
bar_datetime = function(format)
    return {
        name = "Datetime",
        render = function()
            return {
                {
                    text = "      ",
                    fg = l_grey,
                    bg = d_grey
                },
                {
                    text = "  " .. nog.fmt_datetime(show_date and "%d-%m-%y" or "%T") .. "  ",
                    fg = d_grey,
                    bg = green
                }
            }
        end,
        on_click = function()
            show_date = not show_date
        end
    }
end

bar_current_window = function(max_width)
    max_width = max_width or 0

    return {
        name = "CurrentWindow",
        render = function(display_id)
            print("test")
            local win_id = nog.get_focused_win_of_display(display_id)
            local title = win_id and "  " .. nog.get_win_title(win_id) or "    "

            if max_width ~= 0 and string.len(title) > max_width then
                title = title:sub(1, max_width) .. "..."
            end

            return {
                {
                    text = "      ",
                    fg = l_grey,
                    bg = d_grey
                },
                {
                    -- the lenght of the string is fucked for some reason (but also it seems to work ok when checking len in if above???)
                    text = title,
                    fg = d_grey,
                    bg = l_grey
                },
                {
                    text = "  ",
                    fg = l_grey,
                    bg = l_grey
                },
            }
        end
    }
end

require "luacom"



bar_battery_level = function()
    return {
        name = "CurrentWindow",
        render = function()
            Shell = luacom.CreateObject("WScript.Shell")
            Shell:Run ("echo hi", 0)
            return {
                {
                    text = "      ",
                    fg = l_grey,
                    bg = d_grey
                },
                {
                    text = "hi",
                    fg = d_grey,
                    bg = l_grey
                },
            }
        end
    }
end

-- ===============================================================
--                         Config
-- ===============================================================

-- Nog has 9 workspaces - add another and it crashes...
local workspaces = { 1, 2, 3, 4, 5, 6, 7, 8, 9 }

-- Nog settings
nog.config.ignore_fullscreen_actions = true

-- bar
nog.config.bar.font = text_font
nog.config.display_app_bar = true
nog.config.bar.font_size = 20
nog.config.bar.height = 20
nog.config.bar.color = white
nog.config.bar.components = {
    left = {
        nog.components.padding(5),
        bar_datetime(),
        nog.components.padding(5),
        bar_workspaces(),
        nog.components.padding(5),
    },
    center = {
        bar_current_window(40),
    },
    right = {}
}

-- work mode
nog.gbind("alt+shift+w", nog.toggle_work_mode)
nog.config.work_mode = false
nog.config.launch_on_startup = true
nog.config.multi_monitor = true
nog.config.remove_task_bar = true

-- window settings
nog.config.inner_gap = 5;
nog.config.outer_gap = 10;

-- window rules
nog.config.rules = {
    -- ignore snipping tool so it doesnt break
    ["snippingtool.exe"] = { 
        action = "ignore"
    },
    -- ignore explorer cause its cooked in nog
    ["explorer.exe"] = {
        has_custom_titlebar = true,
        chromium = true
    },
    ["firefox.exe"] = {
        has_custom_titlebar = true,
        -- Adds special handling for firefox
        firefox = true
    },
    ["chrome.exe"] = {
        has_custom_titlebar = true,
        -- Adds special handling for chrome
        chromium = true
    },
    ["discord.exe"] = {
        has_custom_titlebar = true,
        workspace_id = 9
    },
    ["spotify.exe"] = {
        has_custom_titlebar = true,
        workspace_id = 8
    },
    ["code.exe"] = {
        has_custom_titlebar = true
    },
}

-- Nog Bindings
nog.nbind("alt+i", nog.win_ignore)
nog.nbind("alt+shift+q", nog.win_close)
nog.nbind("alt+shift+x", nog.quit)

-- Moving windows
nog.nbind_tbl("alt", nog.ws_focus, direction_keys)
nog.nbind_tbl("alt+shift", nog.ws_swap, direction_keys)

-- Direction bindings
nog.nbind("alt+h", function()
    nog.ws_set_split_direction("Vertical")
end)
nog.nbind("alt+v", function()
    nog.ws_set_split_direction("Horizontal")
end)

-- Other window bindings
nog.nbind("alt+shift+space", nog.win_toggle_floating)
nog.nbind("alt+f", nog.ws_toggle_fullscreen)

-- Workspace bindings
nog.nbind_tbl("alt+shift", nog.win_move_to_ws, workspaces)
nog.nbind_tbl("alt", nog.ws_change, workspaces)

-- Launch bindings
nog.gbind("alt+backspace", function()
    nog.launch("C:/Program Files/Microsoft VS Code/Code.exe")
end)

nog.gbind("alt+enter", function()
    nog.launch("C:/Program Files/WindowsApps/Microsoft.WindowsTerminal_1.9.1942.0_x64__8wekyb3d8bbwe/wt.exe")
end)
