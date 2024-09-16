NF = {
	["nf-md-keyboard_return"] = "󰌑",
	["nf-md-keyboard_tab"] = "󰌒 ",
	["nf-md-keyboard_space"] = "󱁐",
}

local g = vim.g
local opt = vim.opt

g.mapleader = " "
g.maplocalleader = " "

g.loaded_gzip = 1
g.loaded_zip = 1
g.loaded_zipPlugin = 1
g.loaded_tar = 1
g.loaded_tarPlugin = 1
g.loaded_getscript = 1
g.loaded_getscriptPlugin = 1
g.loaded_vimball = 1
g.loaded_vimballPlugin = 1
g.loaded_2html_plugin = 1
g.loaded_matchit = 1
g.loaded_matchparen = 1
g.loaded_logiPat = 1
g.loaded_rrhelper = 1

g.loaded_netrw = 1
g.loaded_netrwPlugin = 1
g.loaded_netrwSettings = 1

opt.number = true
opt.mouse = "a"
opt.showmode = false
opt.clipboard = "unnamedplus"
opt.breakindent = true
opt.undofile = true
opt.ignorecase = true
opt.smartcase = true
opt.signcolumn = "yes"
opt.updatetime = 250
opt.timeoutlen = 300
opt.splitright = true
opt.splitbelow = true
opt.list = true
opt.listchars = {
	eol = NF["nf-md-keyboard_return"],
	tab = NF["nf-md-keyboard_tab"],
	trail = "·",
	nbsp = NF["nf-md-keyboard_space"],
	extends = "<",
	precedes = ">",
	conceal = "┊",
}
opt.inccommand = "split"
opt.cursorline = true
opt.scrolloff = 10
opt.hlsearch = true

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
