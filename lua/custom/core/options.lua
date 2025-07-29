local Symbols = require "custom.symbols"

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
  eol = Symbols.nf.md_keyboard_return,
  tab = Symbols.nf.md_keyboard_tab,
  trail = Symbols.unicode.middle_dot,
  nbsp = Symbols.nf.md_keyboard_space,
  extends = "<",
  precedes = ">",
  conceal = Symbols.unicode.light_quadruple_dash_vertical,
}
opt.inccommand = "split"
opt.cursorline = true
opt.scrolloff = 10
opt.hlsearch = true
opt.cmdheight = 0
vim.o.relativenumber = true
vim.o.laststatus = 3
vim.o.winblend = 0
