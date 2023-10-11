-- -- Global Settings --
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opt = {
    noremap = true
    -- silent = true
}

local mode_nv = {"n", "v"}
local mode_v = {"v"}
local mode_i = {"i"}
local mode_a = {"n", "v", "i"}

local nmappings = {
    -- test
    {from = "<C-s>", to = "<ESC>:w<CR>:source<CR>"},
    {from = "qq", to = "<ESC>:q<CR>"},
}

for _, mapping in ipairs(nmappings) do
    vim.keymap.set(mapping.mode or "n", mapping.from, mapping.to, {
        noremap = true
    })
end



-- -- 在插入模式下自动关闭查找高亮
-- vim.cmd('autocmd InsertEnter * set nohlsearch')

-- -- 在搜索时自动开启查找高亮
-- vim.cmd('autocmd CmdlineEnter /\\v.+ set hlsearch')
-- vim.cmd('autocmd CmdlineLeave /\\v.+ set nohlsearch')

-- -- 在普通模式下使用 n 和 N 上下移动时不取消高亮
-- -- vim.cmd('nnoremap <silent> n n:call matchadd("Search", @/, 10)<CR>')
-- -- vim.cmd('nnoremap <silent> N N:call matchadd("Search", @/, 10)<CR>')

-- -- 在普通模式下自动关闭查找高亮
-- vim.cmd('autocmd CursorMoved * set nohlsearch')