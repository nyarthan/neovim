local Util = require("custom.util")

local nmap = Util.nmap

nmap("<left>", '<cmd>echo "Use h to move!"<CR>')
nmap("<right>", '<cmd>echo "Use l to move!"<CR>')
nmap("<up>", '<cmd>echo "Use k to move!"<CR>')
nmap("<down>", '<cmd>echo "Use j to move!"<CR>')

nmap("<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
nmap("<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
nmap("<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
nmap("<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })
