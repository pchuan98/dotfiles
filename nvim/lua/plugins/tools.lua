-- https://github.com/lewis6991/gitsigns.nvim
local git = {
    "lewis6991/gitsigns.nvim",
    lazy = false,
    config = function()
        require("gitsigns").setup()
    end
}

-- https://github.com/RRethy/vim-illuminate
local highlight = {
    "RRethy/vim-illuminate",
    lazy = false,
    config = function()
        local opts = {
            -- providers: provider used to get references in the buffer, ordered by priority
            providers = {'lsp', 'treesitter', 'regex'},
            -- delay: delay in milliseconds
            delay = 100,
            -- filetype_overrides: filetype specific overrides.
            -- The keys are strings to represent the filetype while the values are tables that
            -- supports the same keys passed to .configure except for filetypes_denylist and filetypes_allowlist
            filetype_overrides = {},
            -- filetypes_denylist: filetypes to not illuminate, this overrides filetypes_allowlist
            filetypes_denylist = {'dirbuf', 'dirvish', 'fugitive'},
            -- filetypes_allowlist: filetypes to illuminate, this is overridden by filetypes_denylist
            -- You must set filetypes_denylist = {} to override the defaults to allow filetypes_allowlist to take effect
            filetypes_allowlist = {},
            -- modes_denylist: modes to not illuminate, this overrides modes_allowlist
            -- See `:help mode()` for possible values
            modes_denylist = {},
            -- modes_allowlist: modes to illuminate, this is overridden by modes_denylist
            -- See `:help mode()` for possible values
            modes_allowlist = {},
            -- providers_regex_syntax_denylist: syntax to not illuminate, this overrides providers_regex_syntax_allowlist
            -- Only applies to the 'regex' provider
            -- Use :echom synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name')
            providers_regex_syntax_denylist = {},
            -- providers_regex_syntax_allowlist: syntax to illuminate, this is overridden by providers_regex_syntax_denylist
            -- Only applies to the 'regex' provider
            -- Use :echom synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name')
            providers_regex_syntax_allowlist = {},
            -- under_cursor: whether or not to illuminate under the cursor
            under_cursor = true,
            -- large_file_cutoff: number of lines at which to use large_file_config
            -- The `under_cursor` option is disabled when this cutoff is hit
            large_file_cutoff = nil,
            -- large_file_config: config to use for large files (based on large_file_cutoff).
            -- Supports the same keys passed to .configure
            -- If nil, vim-illuminate will be disabled for large files.
            large_file_overrides = nil,
            -- min_count_to_highlight: minimum number of matches required to perform highlighting
            min_count_to_highlight = 1,
            -- should_enable: a callback that overrides all other settings to
            -- enable/disable illumination. This will be called a lot so don't do
            -- anything expensive in it.
            should_enable = function(bufnr)
                -- Check if the current file has more than 10000 lines
                if vim.api.nvim_buf_line_count(0) > 10000 then
                    return false
                else
                    return true
                end
            end,
            -- case_insensitive_regex: sets regex case sensitivity
            case_insensitive_regex = false
        }

        require("illuminate").configure(opts)
    end

}

local jk = {
    "rainbowhxch/accelerated-jk.nvim",
    config = function()
        local opts = {
            mode = 'time_driven',
            enable_deceleration = false,
            acceleration_motions = {},
            acceleration_limit = 150,
            acceleration_table = {7, 12, 17, 21, 24, 26, 28, 30},
            -- when 'enable_deceleration = true', 'deceleration_table = { {200, 3}, {300, 7}, {450, 11}, {600, 15}, {750, 21}, {900, 9999} }'
            deceleration_table = {{150, 9999}}
        }

        vim.api.nvim_set_keymap('n', 'j', '<Plug>(accelerated_jk_gj)', {})
        vim.api.nvim_set_keymap('n', 'k', '<Plug>(accelerated_jk_gk)', {})
        require("accelerated-jk").setup(opts)
    end
}

local pairs = {
    -- https://github.com/windwp/nvim-autopairs
    "windwp/nvim-autopairs",
    opts = {}
}

local lastplace = {
    "pchuan98/nvim-lastplace",
    lazy = false,
    config = function()
        local opts = {
            lastplace_ignore_buftype = {"quickfix", "nofile", "help"},
            lastplace_ignore_filetype = {"gitcommit", "gitrebase", "svn", "hgcommit"},
            lastplace_open_folds = true
            -- ignore_extension = {"py"}
        }
        require("nvim-lastplace").setup(opts)
    end
}

local flash = {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {{
        "s",
        mode = {"n", "x", "o"},
        function()
            require("flash").jump()
        end,
        desc = "Flash"
    }, {
        "S",
        mode = {"n", "x", "o"},
        function()
            require("flash").treesitter()
        end,
        desc = "Flash Treesitter"
    }, {
        "r",
        mode = "o",
        function()
            require("flash").remote()
        end,
        desc = "Remote Flash"
    }, {
        "R",
        mode = {"o", "x"},
        function()
            require("flash").treesitter_search()
        end,
        desc = "Treesitter Search"
    }, {
        "<c-s>",
        mode = {"c"},
        function()
            require("flash").toggle()
        end,
        desc = "Toggle Flash Search"
    }}
}

local comment = {
    'echasnovski/mini.comment',
    version = false,
    opts = {}
}

local picker = {
    's1n7ax/nvim-window-picker',
    name = 'window-picker',
    event = 'VeryLazy',
    version = '2.*',
    config = function()
        require'window-picker'.setup()
    end
}

local persistence = {
    "folke/persistence.nvim",
    event = "BufReadPre",
    config = function()
        local opts = {
            dir = vim.fn.expand(vim.fn.stdpath("state") .. "/sessions/"),
            options = {"buffers", "curdir", "tabpages", "winsize"},
            pre_save = nil
        }
        require("persistence").setup(opts)

        -- restore the session for the current directory
        vim.api.nvim_set_keymap("n", "<leader>qs", [[<cmd>lua require("persistence").load()<cr>]], {})

        -- restore the last session
        vim.api.nvim_set_keymap("n", "<leader>ql", [[<cmd>lua require("persistence").load({ last = true })<cr>]], {})

        -- stop Persistence => session won't be saved on exit
        vim.api.nvim_set_keymap("n", "<leader>qd", [[<cmd>lua require("persistence").stop()<cr>]], {})
    end
}

return {git, highlight, jk, pairs, lastplace, flash, comment, picker, persistence}

