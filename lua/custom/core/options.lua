local Symbols = require "custom.symbols"

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.number = true
vim.opt.mouse = "a"
vim.opt.showmode = false
vim.opt.clipboard = "unnamedplus"
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.list = true
vim.opt.listchars = {
  eol = Symbols.nf.md_keyboard_return,
  tab = Symbols.nf.md_keyboard_tab,
  trail = Symbols.unicode.middle_dot,
  nbsp = Symbols.nf.md_keyboard_space,
  extends = "<",
  precedes = ">",
  conceal = Symbols.unicode.light_quadruple_dash_vertical,
}
vim.opt.inccommand = "split"
vim.opt.cursorline = true
vim.opt.scrolloff = 10
vim.opt.hlsearch = true
vim.opt.cmdheight = 0
vim.o.relativenumber = true
vim.o.laststatus = 3
vim.o.winblend = 0
