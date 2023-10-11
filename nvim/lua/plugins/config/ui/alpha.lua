local log_chuan = [[
██████╗ ██╗  ██╗██╗   ██╗ █████╗ ███╗   ██╗      ███╗   ██╗██╗   ██╗██╗███╗   ███╗
██╔════╝██║  ██║██║   ██║██╔══██╗████╗  ██║      ████╗  ██║██║   ██║██║████╗ ████║
██║     ███████║██║   ██║███████║██╔██╗ ██║█████╗██╔██╗ ██║██║   ██║██║██╔████╔██║
██║     ██╔══██║██║   ██║██╔══██║██║╚██╗██║╚════╝██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║
╚██████╗██║  ██║╚██████╔╝██║  ██║██║ ╚████║      ██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║
 ╚═════╝╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═══╝      ╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝
]]


local log_nvim = [[
[███╗   ██╗    ██╗   ██╗    ██╗    ███╗   ███╗
[████╗  ██║    ██║   ██║    ██║    ████╗ ████║
[██╔██╗ ██║    ██║   ██║    ██║    ██╔████╔██║
[██║╚██╗██║    ╚██╗ ██╔╝    ██║    ██║╚██╔╝██║
[██║ ╚████║     ╚████╔╝     ██║    ██║ ╚═╝ ██║
[╚═╝  ╚═══╝      ╚═══╝      ╚═╝    ╚═╝     ╚═╝
]]


return function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")

    local default_terminal = {
        type = "terminal",
        command = nil,
        width = 69,
        height = 8,
        opts = {
            redraw = true,
            window_config = {}
        }
    }

    local function pick_color()
        math.randomseed(os.time())
        local colors = {"String", "Identifier", "Keyword", "Number"}
        return colors[math.random(#colors)]
    end

    local header = {
        type = "text",
        val = vim.split(log_chuan, "\n"),

        opts = {
            position = "center",
            hl = pick_color()
            -- wrap = "overflow";
        }
    }

    local buttons = {
        type = "group",
        val = {
            dashboard.button("f", " " .. " Find file", "<cmd> Telescope find_files <cr>"),
            dashboard.button("n", " " .. " New file", "<cmd> ene <BAR> startinsert <cr>"),
            dashboard.button("r", " " .. " Recent files", "<cmd> Telescope oldfiles <cr>"),
            dashboard.button("g", " " .. " Find text", "<cmd> Telescope live_grep <cr>"),
            dashboard.button("c", " " .. " Config", "<cmd> e $MYVIMRC <cr>"),
            dashboard.button("s", " " .. " Restore Session", [[<cmd> lua require("persistence").load() <cr>]]),
            dashboard.button("l", "󰒲 " .. " Lazy", "<cmd> Lazy <cr>"),
            dashboard.button("q", " " .. " Quit", "<cmd> qa <cr>"),
        },
        opts = {
            spacing = 1
        }
    }

    local function generate_footer()
        -- local total_plugins = #vim.tbl_keys(packer_plugins)
        local total_plugins = ""
        local datetime = os.date(" %d-%m-%Y   %H:%M:%S")
        local version = vim.version()
        local nvim_version_info = "   v" .. version.major .. "." .. version.minor .. "." .. version.patch

        return datetime .. "   " .. total_plugins .. " plugins" .. nvim_version_info
    end

    local footer = {
        type = "text",
        val = generate_footer(),
        opts = {
            position = "center",
            hl = "Number"
        }
    }

    dashboard.section.terminal.type = "terminal"
    dashboard.section.terminal.command = nil
    dashboard.section.terminal.width = 69
    dashboard.section.terminal.height = 100
    dashboard.section.terminal.opts = {
        redraw = false,
        window_config = {}
    }

    dashboard.section.header.val = header.val
    dashboard.section.header.opts = header.opts

    dashboard.section.buttons.val = buttons.val
    dashboard.section.buttons.opts = {
        spacing = 1
    }

    dashboard.section.footer.val = footer.val
    dashboard.section.footer.opts = footer.opts

    dashboard.config.layout = {{
        type = "padding",
        val = 12
    }, dashboard.section.header, {
        type = "padding",
        val = 3
    }, dashboard.section.buttons, {
        type = "padding",
        val = 2
    }, dashboard.section.footer}

    dashboard.config.opts = {
        margin = 0
    }

    alpha.setup(dashboard.opts)
end

