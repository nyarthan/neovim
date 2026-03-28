local Util = require "custom.util"

local nmap = Util.nmap
local make_cmd = Util.make_cmd

nmap("<Esc>", make_cmd "nohlsearch", { desc = "Stop highlighting current search" })

nmap("<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
nmap("<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
nmap("<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
nmap("<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

nmap("gd", function() vim.lsp.buf.definition() end, { desc = "[G]o to [D]efinition" })
nmap("<leader>ga", function() vim.lsp.buf.code_action() end, { desc = "[G]o, Code [Action]!" })
