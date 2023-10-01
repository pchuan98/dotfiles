-- All plugins have lazy=true by default,to load a plugin on startup just lazy=false
-- List of all default plugins & their definitions
local plugins = {{
    -- https://github.com/folke/tokyonight.nvim
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
        require("tokyonight").setup(require("plugins.config.tokyo"))
        vim.cmd([[colorscheme tokyonight-storm]])
    end
}, {
    -- https://github.com/nvim-lualine/lualine.nvim
    "nvim-lualine/lualine.nvim",
    lazy = false,
    dependencies = {"nvim-tree/nvim-web-devicons", "nvim-lua/lsp-status.nvim"},
    config = require("plugins.config.lualine")
}, {
    -- https://github.com/utilyre/barbecue.nvim
    "utilyre/barbecue.nvim",
    name = "barbecue",
    version = "*",
    dependencies = {"SmiteshP/nvim-navic", "nvim-tree/nvim-web-devicons"},
    opts = require("plugins.config.barbecue")
}, {
    -- https://github.com/akinsho/bufferline.nvim
    "akinsho/bufferline.nvim",
    dependencies = {"nvim-tree/nvim-web-devicons"},
    lazy = false,
    config = function()
        require("bufferline").setup()
    end
}, {
    -- https://github.com/lewis6991/gitsigns.nvim
    "lewis6991/gitsigns.nvim",
    lazy = false,
    config = function()
        require("gitsigns").setup()
    end
}, {
    -- https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-indentscope.md
    'echasnovski/mini.indentscope',
    version = false,
    opts = require("plugins.config.indentscope")
}, {
    -- https://github.com/lukas-reineke/indent-blankline.nvim
    -- "lukas-reineke/indent-blankline.nvim",
    -- main = "ibl",
    -- opts = {}
}, {
    -- https://github.com/goolord/alpha-nvim
    'goolord/alpha-nvim',
    config = function()
        require'alpha'.setup(require'alpha.themes.dashboard'.config)
    end
}, {
    -- https://github.com/RRethy/vim-illuminate
    "RRethy/vim-illuminate",
    lazy = false
    -- config = function()
    --     require("illuminate").setup()
    -- end
}}

return plugins
