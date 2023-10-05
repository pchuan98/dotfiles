-- https://microsoft.github.io/language-server-protocol/implementors/servers/
return {{
    "neovim/nvim-lspconfig",
    config = function()
        local lspconfig = require('lspconfig')
        lspconfig.pyright.setup {}
    end
}, -- https://github.com/williamboman/mason-lspconfig.nvim 
{
    "williamboman/mason-lspconfig.nvim",
    dependencies = {{ -- https://github.com/williamboman/mason.nvim
        "williamboman/mason.nvim",
        lazy = false,
        dependencies = {},
        opts = {}
    }},
    opts = {
        ensure_installed = {"pyright"},
        automatic_installation = true,
        handlers = nil
    }
}}
