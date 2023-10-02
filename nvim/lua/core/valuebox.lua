local M = {}

-- ["tokyonight","tokyodark"]
M.theme = "tokyonight"

M.load_theme = function()
    if M.theme == "tokyonight" then
        vim.cmd("colorscheme tokyonight")
    elseif M.theme == "tokyodark" then
        vim.cmd("colorscheme tokyodark")
    else
        vim.notify("Current theme is not supported")
    end
end

M.lualine_color = {
    bg = '#202328',
    fg = '#bbc2cf',
    yellow = '#ECBE7B',
    cyan = '#008080',
    darkblue = '#081633',
    green = '#98be65',
    orange = '#FF8800',
    violet = '#a9a1e1',
    magenta = '#c678dd',
    blue = '#51afef',
    red = '#ec5f67'
}

M.lualine_mode_color = {
    n = M.lualine_color.red,
    i = M.lualine_color.green,
    v = M.lualine_color.blue,
    [''] = M.lualine_color.blue,
    V = M.lualine_color.blue,
    c = M.lualine_color.magenta,
    no = M.lualine_color.red,
    s = M.lualine_color.orange,
    S = M.lualine_color.orange,
    [''] = M.lualine_color.orange,
    ic = M.lualine_color.yellow,
    R = M.lualine_color.violet,
    Rv = M.lualine_color.violet,
    cv = M.lualine_color.red,
    ce = M.lualine_color.red,
    r = M.lualine_color.cyan,
    rm = M.lualine_color.cyan,
    ['r?'] = M.lualine_color.cyan,
    ['!'] = M.lualine_color.red,
    t = M.lualine_color.red
}

M.barbecue_kind = {
    File = "",
    Module = "",
    Namespace = "",
    Package = "",
    Class = "",
    Method = "",
    Property = "",
    Field = "",
    Constructor = "",
    Enum = "",
    Interface = "",
    Function = "",
    Variable = "",
    Constant = "",
    String = "",
    Number = "",
    Boolean = "",
    Array = "",
    Object = "",
    Key = "",
    Null = "",
    EnumMember = "",
    Struct = "",
    Event = "",
    Operator = "",
    TypeParameter = ""
}

return M
