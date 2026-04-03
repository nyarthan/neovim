require("mini.base16").setup {
  palette = {
    base00 = "#080808",
    base01 = "#141414",
    base02 = "#1C1C1C",
    base03 = "#505050",
    base04 = "#A0A0A0",
    base05 = "#EDE5DB",
    base06 = "#F2ECE4",
    base07 = "#F7F2EC",
    base08 = "#FF8080",
    base09 = "#FFC799",
    base0A = "#FFC799",
    base0B = "#99FFE4",
    base0C = "#A0A0A0",
    base0D = "#FFC799",
    base0E = "#A0A0A0",
    base0F = "#FF8080",
  },
}

-- Vesper-style overrides: variables and identifiers stay white
local hi = vim.api.nvim_set_hl
hi(0, "@variable", { fg = "#EDE5DB" })
hi(0, "@property", { fg = "#EDE5DB" })
hi(0, "@variable.parameter", { fg = "#EDE5DB" })
hi(0, "@variable.member", { fg = "#EDE5DB" })
hi(0, "@tag", { fg = "#FFC799" })
hi(0, "@tag.attribute", { fg = "#FFC799" })

require("mini.icons").setup()

require("mini.completion").setup {
  lsp_completion = { source_func = "omnifunc", auto_setup = false },
}

vim.api.nvim_create_autocmd("LspAttach", {
  pattern = "*",
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    client.server_capabilities.semanticTokensProvider = nil
    vim.bo[args.buf].omnifunc = "v:lua.MiniCompletion.completefunc_lsp"
  end,
})

local capabilities = vim.tbl_deep_extend(
  "force",
  vim.lsp.protocol.make_client_capabilities(),
  MiniCompletion.get_lsp_capabilities { resolve_additional_text_edits = false }
)
capabilities.textDocument.formatting = nil
capabilities.textDocument.rangeFormatting = nil

vim.lsp.config("*", {
  capabilities = capabilities,
  init_options = { hostInfo = "neovim" },
  root_markers = { ".git/" },
})

require("mini.bracketed").setup {
  buffer = { suffix = "b", options = {} },
  comment = { suffix = "c", options = {} },
  conflict = { suffix = "x", options = {} },
  diagnostic = { suffix = "d", options = {} },
  file = { suffix = "f", options = {} },
  indent = { suffix = "i", options = {} },
  jump = { suffix = "j", options = {} },
  location = { suffix = "l", options = {} },
  oldfile = { suffix = "o", options = {} },
  quickfix = { suffix = "p", options = {} },
  treesitter = { suffix = "t", options = {} },
  undo = { suffix = "u", options = {} },
  window = { suffix = "w", options = {} },
  yank = { suffix = "y", options = {} },
}

require("mini.diff").setup {
  view = { style = "sign", priority = 199 },
  mappings = {
    apply = "gh",
    reset = "gH",
    textobject = "gh",
    goto_first = "[H",
    goto_prev = "[h",
    goto_next = "]h",
    goto_last = "]H",
  },
}

local files = require "mini.files"
files.setup { windows = { preview = true } }

vim.api.nvim_create_autocmd("User", {
  pattern = "MiniFilesActionRename",
  callback = function(event) Snacks.rename.on_rename_file(event.data.from, event.data.to) end,
})

vim.keymap.set(
  "n",
  "<leader>e",
  function() MiniFiles.open(vim.api.nvim_buf_get_name(0)) end,
  { desc = "Open File [E]xplorer" }
)

local hipatterns = require "mini.hipatterns"
hipatterns.setup {
  highlighters = {
    fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
    todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
    note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
    hex_color = hipatterns.gen_highlighter.hex_color(),
  },
}

local indentscope = require "mini.indentscope"
indentscope.setup {
  draw = {
    delay = 0,
    animation = indentscope.gen_animation.none(),
  },
}

require("mini.jump").setup {
  mappings = {
    forward = "f",
    backward = "F",
    forward_till = "t",
    backward_till = "T",
    repeat_jump = ";",
  },
}

require("mini.move").setup {
  mappings = {
    left = "<M-h>",
    right = "<M-l>",
    down = "<M-j>",
    up = "<M-k>",
    line_left = "<M-h>",
    line_right = "<M-l>",
    line_down = "<M-j>",
    line_up = "<M-k>",
  },
}

require("mini.pairs").setup {}

require("mini.pick").setup {
  mappings = { choose_marked = "<C-q>" },
}

vim.keymap.set("n", "<leader>ff", function() MiniPick.builtin.files() end, { desc = "Find Files" })
vim.keymap.set(
  "n",
  "<leader>fg",
  function() MiniPick.builtin.grep_live() end,
  { desc = "Find Grep" }
)
vim.keymap.set(
  "n",
  "<leader>fr",
  function() MiniPick.builtin.resume() end,
  { desc = "Find Resume" }
)

require("mini.sessions").setup {}

require("mini.starter").setup {
  -- font: DOS Rebel
  header = [[
                                         ███
                                        ░░░
 ████████    ██████   ██████  █████ █████ ████  █████████████
░░███░░███  ███░░███ ███░░███░░███ ░░███ ░░███ ░░███░░███░░███
 ░███ ░███ ░███████ ░███ ░███ ░███  ░███  ░███  ░███ ░███ ░███
 ░███ ░███ ░███░░░  ░███ ░███ ░░███ ███   ░███  ░███ ░███ ░███
 ████ █████░░██████ ░░██████   ░░█████    █████ █████░███ █████
░░░░ ░░░░░  ░░░░░░   ░░░░░░     ░░░░░    ░░░░░ ░░░░░ ░░░ ░░░░░ ]],
}

local statusline = require "mini.statusline"
statusline.setup {
  content = {
    active = function()
      local mode, mode_hl = statusline.section_mode { trunc_width = 120 }
      local git = statusline.section_git { trunc_width = 40 }
      local diff = statusline.section_diff { trunc_width = 75 }
      local diagnostics = statusline.section_diagnostics { trunc_width = 75 }
      local filename = statusline.section_filename { trunc_width = 140 }
      local fileinfo = statusline.section_fileinfo { trunc_width = 120 }
      local location = statusline.section_location { trunc_width = 75 }
      local search = statusline.section_searchcount { trunc_width = 75 }
      local lsp = statusline.section_lsp { trunc_width = 75 }

      return statusline.combine_groups {
        { hl = mode_hl, strings = { mode } },
        { hl = "MiniStatuslineDevInfo", strings = { git, diff, diagnostics, lsp } },
        "%<",
        { hl = "MiniStatuslineFilename", strings = { filename } },
        "%=",
        { hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
        { hl = mode_hl, strings = { search, location } },
      }
    end,
  },
}

require("mini.surround").setup {
  mappings = {
    add = "sa",
    delete = "sd",
    find = "sf",
    find_left = "sF",
    highlight = "sh",
    replace = "sr",
    update_n_lines = "sn",
  },
}

require("nvim-treesitter").setup {
  auto_install = false,
  highlight = { enable = true },
  indent = { enable = true },
  additional_vim_regex_highlighting = false,
}

require("nvim-ts-autotag").setup {
  opts = {
    enable_close = true,
    enable_rename = true,
    enable_close_on_slash = true,
  },
}

require("ts_context_commentstring").setup { enable_autocmd = false }

local get_option = vim.filetype.get_option
---@diagnostic disable-next-line: duplicate-set-field
vim.filetype.get_option = function(filetype, option)
  if option == "commentstring" then
    return require("ts_context_commentstring.internal").calculate_commentstring()
  else
    return get_option(filetype, option)
  end
end

require("snacks").setup {
  bigfile = { enabled = true },
  bufdelete = { enabled = true },
  notifier = { enabled = true },
  quickfile = { enabled = true },
  rename = { enabled = true },
  picker = { enabled = false },
  statuscolumn = {
    enabled = true,
    left = { "mark", "sign" },
    right = { "fold", "git" },
    folds = { open = false, git_hl = false },
    git = { patterns = { "GitSign", "MiniDiffSign" } },
    refresh = 50,
  },
}

require("trouble").setup { focus = true }

require("conform").setup {
  formatters_by_ft = {
    lua = { "stylua" },
    nix = { "nixfmt" },
    javascript = { "prettier" },
    javascriptReact = { "prettier" },
    typescript = { "prettier" },
    typescriptReact = { "prettier" },
  },
  format_on_save = {
    timeout_ms = 500,
    lsp_format = "fallback",
  },
}

vim.cmd "packadd justify"
vim.cmd "packadd nohlsearch"
vim.cmd "packadd nvim.undotree"
vim.keymap.set("n", "<lader>u", require("undotree").open)
