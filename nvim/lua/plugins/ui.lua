local colorschemes = { -- https://github.com/folke/tokyonight.nvim
{
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
        require("tokyonight").setup(require("plugins.config.ui.tokyo"))
        -- vim.cmd([[colorscheme tokyonight-storm]])
    end
}, -- https://github.com/tiagovla/tokyodark.nvim 
{
    "tiagovla/tokyodark.nvim",
    lazy = false,
    priority = 1000,
    opts = {
        transparent_background = true,
        gamma = 1.5
    },
    config = function(_, opts)
        require("tokyodark").setup(opts)
        -- vim.cmd [[colorscheme tokyodark]]
    end
}, -- https://github.com/catppuccin/nvim
{
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = require("plugins.config.ui.catppuccin")
}}

local indent = { -- https://github.com/lukas-reineke/indent-blankline.nvim
{
    "lukas-reineke/indent-blankline.nvim",
    -- event = "LazyFile",
    opts = {
        indent = {
            char = "│",
            tab_char = "│"
        },
        scope = {
            enabled = false
        },
        exclude = {
            filetypes = {"help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy", "mason", "notify", "toggleterm",
                         "lazyterm"}
        }
    },
    main = "ibl"
} -- https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-indentscope.md
, {
    "echasnovski/mini.indentscope",
    version = false,
    opts = require("plugins.config.ui.indent"),
    init = function()
        vim.api.nvim_create_autocmd("FileType", {
            pattern = {"help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy", "mason", "notify", "toggleterm",
                       "lazyterm"},
            callback = function()
                vim.b.miniindentscope_disable = true
            end
        })
    end
}}

local tree = -- https://github.com/nvim-neo-tree/neo-tree.nvim
{
    "nvim-neo-tree/neo-tree.nvim",
    cmd = "Neotree",
    branch = "v3.x",
    keys = {{
        "<leader>t",
        function()
            require("neo-tree.command").execute({
                toggle = true,
                dir = vim.fn.expand('%:p:h')
            })
        end,
        desc = "Explorer NeoTree (root dir)"
    }},
    dependencies = {"nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", "MunifTanjim/nui.nvim"},
    init = function()
        -- open neotree when vim is called with a directory argument
        if vim.fn.argc() == 1 then
            local stat = vim.loop.fs_stat(vim.fn.argv(0))
            if stat and stat.type == "directory" then
                require("neo-tree")
            end
        end
    end,
    opts = require("plugins.config.ui.neotree"),
    config = function(_, opts)
        require("neo-tree").setup(opts)
    end
}

local bar = { -- https://github.com/nvim-lualine/lualine.nvim
{
    "nvim-lualine/lualine.nvim",
    lazy = false,
    dependencies = {"nvim-tree/nvim-web-devicons", "nvim-lua/lsp-status.nvim"},
    config = require("plugins.config.ui.lualine")
} -- https://github.com/utilyre/barbecue.nvim
, {
    "utilyre/barbecue.nvim",
    name = "barbecue",
    version = "*",
    dependencies = {"SmiteshP/nvim-navic", "nvim-tree/nvim-web-devicons"},
    opts = require("plugins.config.ui.barbecue")
} -- https://github.com/akinsho/bufferline.nvim
, {
    "akinsho/bufferline.nvim",
    dependencies = {"nvim-tree/nvim-web-devicons", {
        'echasnovski/mini.bufremove',
        version = false
    }},
    lazy = false,
    opts = require("plugins.config.ui.bufferline")
}}

local board = -- https://github.com/goolord/alpha-nvim
{
    'goolord/alpha-nvim',
    config = require("plugins.config.ui.alpha")
}

local utils = { -- https://github.com/rcarriga/nvim-notify
{
    "rcarriga/nvim-notify",
    lazy = false,
    keys = {{
        "<leader>un",
        function()
            require("notify").dismiss({
                silent = true,
                pending = true
            })
        end,
        desc = "Dismiss all Notifications"
    }},
    opts = require("plugins.config.ui.notify")
}, -- https://github.com/folke/which-key.nvim
{
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
        vim.o.timeout = true
        vim.o.timeoutlen = 300
    end,
    opts = require("plugins.config.ui.whichkey"),
    config = function(_, opts)
        local wk = require("which-key")
        wk.setup(opts)
        wk.register(opts.defaults)
    end
}, -- https://github.com/stevearc/dressing.nvim 
{
    'stevearc/dressing.nvim',
    init = function()
        ---@diagnostic disable-next-line: duplicate-set-field
        vim.ui.select = function(...)
            require("dressing.nvim")
            return vim.ui.select(...)
        end
        ---@diagnostic disable-next-line: duplicate-set-field
        vim.ui.input = function(...)
            require("dressing.nvim")
            return vim.ui.input(...)
        end
    end,
    opts = {}
}, -- https://github.com/folke/noice.nvim
{
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
        -- add any options here
    },
    dependencies = { -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
    "MunifTanjim/nui.nvim", -- OPTIONAL:
    --   `nvim-notify` is only needed, if you want to use the notification view.
    --   If not available, we use `mini` as the fallback
    "rcarriga/nvim-notify", "stevearc/dressing.nvim"},
    opts = require("plugins.config.ui.noice"),
    config = function(_, opts)
        require("noice").setup(opts)
    end,
    keys = {{
        "<S-Enter>",
        function()
            require("noice").redirect(vim.fn.getcmdline())
        end,
        mode = "c",
        desc = "Redirect Cmdline"
    }, {
        "<leader>snl",
        function()
            require("noice").cmd("last")
        end,
        desc = "Noice Last Message"
    }, {
        "<leader>snh",
        function()
            require("noice").cmd("history")
        end,
        desc = "Noice History"
    }, {
        "<leader>sna",
        function()
            require("noice").cmd("all")
        end,
        desc = "Noice All"
    }, {
        "<leader>snd",
        function()
            require("noice").cmd("dismiss")
        end,
        desc = "Dismiss All"
    }, {
        "<c-f>",
        function()
            if not require("noice.lsp").scroll(4) then
                return "<c-f>"
            end
        end,
        silent = true,
        expr = true,
        desc = "Scroll forward",
        mode = {"i", "n", "s"}
    }, {
        "<c-b>",
        function()
            if not require("noice.lsp").scroll(-4) then
                return "<c-b>"
            end
        end,
        silent = true,
        expr = true,
        desc = "Scroll backward",
        mode = {"i", "n", "s"}
    }}
}}

return {colorschemes, indent, tree, bar, board, utils}
