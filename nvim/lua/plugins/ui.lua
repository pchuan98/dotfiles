return { -- https://github.com/folke/tokyonight.nvim
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
} -- https://github.com/nvim-lualine/lualine.nvim
, {

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
    dependencies = {"nvim-tree/nvim-web-devicons"},
    lazy = false,
    config = function()
        require("bufferline").setup()
    end
} -- https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-indentscope.md
, {
    'echasnovski/mini.indentscope',
    version = false,
    opts = require("plugins.config.indentscope")
} -- https://github.com/goolord/alpha-nvim
, {
    'goolord/alpha-nvim',
    config = function()
        require'alpha'.setup(require'alpha.themes.dashboard'.config)
    end
}, {
    "rcarriga/nvim-notify",
    lazy = false,
    priority = 1000,
    config = function()
        require("notify").setup({})

        vim.notify = require("notify")
    end
}, {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {"nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim"},
    config = function()
        require("neo-tree").setup()
        vim.keymap.set("n", "<leader>t", [[<cmd>Neotree toggle<cr>]])
    end
}, {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
        vim.o.timeout = true
        vim.o.timeoutlen = 300
    end,
    opts = {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
    }
}, {
    'stevearc/dressing.nvim',
    opts = {}
}, {
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
    config = function()
        require("noice").setup({
            lsp = {
                -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                    ["cmp.entry.get_documentation"] = true
                }
            },
            -- you can enable a preset for easier configuration
            presets = {
                bottom_search = true, -- use a classic bottom cmdline for search
                command_palette = true, -- position the cmdline and popupmenu together
                long_message_to_split = true, -- long messages will be sent to a split
                inc_rename = false, -- enables an input dialog for inc-rename.nvim
                lsp_doc_border = false -- add a border to hover docs and signature help
            }
        })
    end
}}
