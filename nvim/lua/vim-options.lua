
local keymap = vim.keymap

keymap.set("n", "s<up>",    ":above split<cr>",     {silent = true, noremap = true})
keymap.set("n", "s<down>",  ":below split<cr>",     {silent = true, noremap = true})
keymap.set("n", "s<right>", ":vs<cr>",              {silent = true, noremap = true})
keymap.set("n", "s<left>",  ":leftabove split<cr>", {silent = true, noremap = true})

keymap.set("n", "<C-d>",    "yyp",                  {silent = true, noremap = true})
keymap.set("v", "<C-d>",    "y'>p",                 {silent = true, noremap = true})

keymap.set("n", "<M-UP>",   ":m .-2<CR>==",         {silent = true, noremap = true})
keymap.set("n", "<M-DOWN>", ":m .+1<CR>==",         {silent = true, noremap = true})

local options = {

				termguicolors = true,

				mouse = 'a',

				splitbelow = true,
				splitright = true,

				ruler = true,
				number = true,
				cursorline = true,
				numberwidth = 4,

				tabstop = 4,
				shiftwidth = 4,
				softtabstop = 4,

				expandtab = true,
				autoindent = true,
				smartindent = true,

                modifiable = true,
}

for k, v in pairs(options) do
	vim.opt[k] = v
end

vim.g.mapleader = ' '

vim.g.loaded_netrw = 1
vim.g.load = 1
