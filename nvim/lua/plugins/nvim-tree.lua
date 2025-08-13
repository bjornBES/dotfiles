
local keymap = vim.keymap

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.termguicolors = true

local HEIGHT_RATIO = 0.8
local WIDTH_RATIO = 0.5

local isFloating = false

local function configFloat(value)
    require("nvim-tree").setup({
        view = {
            float = {
                enable = value,
                open_win_config = function()
                    local screen_w = vim.opt.columns:get()
                    local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
                    local window_w = screen_w * WIDTH_RATIO
                    local window_h = screen_h * HEIGHT_RATIO
                    local window_w_int = math.floor(window_w)
                    local window_h_int = math.floor(window_h)
                    local center_x = (screen_w - window_w) / 2
                    local center_y = ((vim.opt.lines:get() - window_h) / 2) - vim.opt.cmdheight:get()
                    return {
                        border = 'rounded',
                        relative = 'editor',
                        row = center_y,
                        col = center_x,
                        width = window_w_int,
                        height = window_h_int,
                    }
                end,
            },
        }
    })
end

local function OpenTreeFloat()
    local api = require "nvim-tree.api"
    local view = require "nvim-tree.view"

    if api.tree.is_visible() then
        api.tree.toggle()
    else
        configFloat(true)
        view.width = function() return math.floor(vim.opt.columns:get() * WIDTH_RATIO) end
        api.tree.toggle()
    end
end

local function OpenTreeFixed()
    local api = require("nvim-tree.api")
    local view = require "nvim-tree.view"

    if api.tree.is_visible() then
        api.tree.toggle()
    else
        configFloat(false)
        view.width = 50
        api.tree.toggle()
    end
end

local function CloseTreeFloat()
    local api = require("nvim-tree.api")
    if api.tree.is_visible() and isFloating then
        OpenTreeFloat()
    end
end

keymap.set("n", "<C-o>",        ":NvimTreeOpen<cr>",            {silent = true, noremap = true})
keymap.set("n", "<C-f>",        ":NvimTreeFocus<cr>",            {silent = true, noremap = true})

local function AttachAll(bufnr)
    local api = require("nvim-tree.api")

    local function opts(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end

    keymap.set("n", "<C-v>",        OpenTreeFloat,              {silent = true, noremap = true})
    keymap.set('n', "<C-b>",        OpenTreeFixed,              {silent = true, noremap = true})

    keymap.set('n', "<C-n>",        api.fs.create,              {silent = true, noremap = true})
    keymap.set('n', "<C-d>",        api.fs.remove,              {silent = true, noremap = true})
    keymap.set('n', "<C-r>",        api.fs.rename,              {silent = true, noremap = true})

    keymap.set('n', "<x>",          api.fs.cut,                 {silent = true, noremap = true})
    keymap.set('n', "<p>",          api.fs.paste,               {silent = true, noremap = true})
    keymap.set('n', "<c>",          api.fs.copy.node,           {silent = true, noremap = true})
    keymap.set('n', "<C-a>",        api.fs.copy.absolute_path,  {silent = true, noremap = true})
    keymap.set('n', "<C-r>",        api.fs.copy.relative_path,  {silent = true, noremap = true})
    keymap.set('n', "<C-f>",        api.fs.copy.filename,       {silent = true, noremap = true})

    keymap.set('n', "<C-pcb>",      api.fs.print_clipboard,     {silent = true, noremap = true})

    keymap.set("n", "<Esc>",        CloseTreeFloat,             {silent = true, noremap = true})

    keymap.set("n", "<C-UP>",       api.node.navigate.parent,       opts('Parent Directory'))
    keymap.set("n", "<CR>",         api.node.open.edit,             opts('Open'))

--    keymap.set("n", "",             api.tree.change_root_to_parent, opts(''))
--    keymap.set("n", "",             api.tree.change_root_to_parent, opts(''))

    keymap.set("n", "<C-h>",        api.node.open.horizontal,       opts('Open: Horizontal split'))
    keymap.set("n", "<C-v>",        api.node.open.vertical,         opts('Open: Vertical split'))
end

return {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    config = function ()
        require("nvim-tree").setup(
	    {
            on_attach = AttachAll,
            view = {
                side = "right",
                float = {
                    open_win_config = function()
                        local screen_w = vim.opt.columns:get()
                        local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
                        local window_w = screen_w * WIDTH_RATIO
                        local window_h = screen_h * HEIGHT_RATIO
                        local window_w_int = math.floor(window_w)
                        local window_h_int = math.floor(window_h)
                        local center_x = (screen_w - window_w) / 2
                        local center_y = ((vim.opt.lines:get() - window_h) / 2) - vim.opt.cmdheight:get()
                        return {
                            border = 'rounded',
                            relative = 'editor',
                            row = center_y,
                            col = center_x,
                            width = window_w_int,
                            height = window_h_int,
                        }
                    end,
                }
            }
        }
    )
    end
};
