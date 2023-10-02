local colors = require("core.valuebox").lualine_color
local mode_color = require("core.valuebox").lualine_mode_color

local conditions = {
    buffer_not_empty = function()
        return vim.fn.empty(vim.fn.expand('%:t')) ~= 1
    end,
    hide_in_width = function()
        return vim.fn.winwidth(0) > 80
    end,
    check_git_workspace = function()
        local filepath = vim.fn.expand('%:p:h')
        local gitdir = vim.fn.finddir('.git', filepath .. ';')
        return gitdir and #gitdir > 0 and #gitdir < #filepath
    end
}

local theme = function()
    local default_theme = {
        fg = colors.fg,
        bg = colors.bg
    }

    local default_section = {
        a = default_theme,
        b = default_theme,
        c = default_theme
    }

    return {
        normal = default_section,
        insert = default_section,
        visual = default_section,
        replace = default_section,
        inactive = default_section
    }
end

local options = {
    icons_enabled = true,
    theme = theme(),
    component_separators = "",
    section_separators = "",
    disabled_filetypes = {
        statusline = {},
        winbar = {}
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
        statusline = 1000,
        tabline = 1000,
        winbar = 1000
    }
}

local left_flag = {
    function()
        return '▊'
    end,
    color = {
        fg = colors.blue
    },
    padding = {
        left = 0,
        right = 1
    }
}

local right_flag = {
    function()
        return '▊'
    end,
    color = {
        fg = colors.blue
    },
    padding = {
        left = 1
    }
}

local mode = {
    -- mode component
    function()
        return ''
    end,
    color = function()
        return {
            fg = mode_color[vim.fn.mode()]
        }
    end,
    padding = {
        right = 1
    },
    bg = ""
}

local filesize = {
    -- filesize component
    'filesize',
    cond = conditions.buffer_not_empty
}

local branch = {
    'branch',
    icon = '',
    color = {
        fg = colors.violet,
        gui = 'bold'
    }
}

local diff = {
    'diff',
    symbols = {
        added = ' ',
        modified = '󰝤 ',
        removed = ' '
    },
    diff_color = {
        added = {
            fg = colors.green
        },
        modified = {
            fg = colors.orange
        },
        removed = {
            fg = colors.red
        }
    },
    cond = conditions.hide_in_width
}

local progress = {
    'progress',
    color = {
        fg = colors.fg,
        gui = 'bold'
    }
}

local encoding = {
    'o:encoding',
    fmt = string.upper,
    cond = conditions.hide_in_width,
    color = {
        fg = colors.fg
    }
}

local fileformat = {
    'fileformat',
    fmt = string.upper,
    icons_enabled = true,
    color = {
        fg = colors.fg
    }
}

local filetype = {
    "filetype",
    fmt = string.lower,
    icons_enabled = false,
    color = {
        fg = colors.fg
    }
}

local lsp = {
    function()
        local msg = '%= '
        local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
        local clients = vim.lsp.get_active_clients()
        if next(clients) == nil then
            return msg
        end
        for _, client in ipairs(clients) do
            local filetypes = client.config.filetypes
            if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
                return client.name
            end
        end
        return msg
    end,
    color = {
        fg = '#ffffff',
        gui = 'bold'
    }
}

return function()
    local lualine = require('lualine')

    local config = {
        options = options,
        sections = {
            lualine_a = {left_flag, mode},
            lualine_b = {filesize, branch, progress, 'diff', 'diagnostics'},
            lualine_c = {lsp},
            lualine_x = {'location', encoding, fileformat, filetype},
            lualine_y = {},
            lualine_z = {right_flag}
        },
        inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = {},
            lualine_x = {},
            lualine_y = {},
            lualine_z = {}
        },
        extensions = {"quickfix"}
    }

    lualine.setup(config)
end
