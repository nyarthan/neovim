local Util = require("custom.util")

local bind = Util.bind
local nmap = Util.nmap
local make_cmd = Util.make_cmd

nmap("<Esc>", make_cmd("nohlsearch"), { desc = "Stop highlighting current search" })

nmap("<Left>", bind(print, "Use h to move left"), { desc = [[Arrow navigation is "disabled"]] })
nmap("<Right>", bind(print, "Use l to move right"), { desc = [[Arrow navigation is "disabled"]] })
nmap("<Up>", bind(print, "Use k to move up"), { desc = [[Arrow navigation is "disabled"]] })
nmap("<Down>", bind(print, "Use j to move!"), { desc = [[Arrow navigation is "disabled"]] })

nmap("<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
nmap("<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
nmap("<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
nmap("<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })
