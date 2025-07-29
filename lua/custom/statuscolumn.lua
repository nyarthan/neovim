local Symbols = require "custom.symbols"

local M = {}

local function get_line_number_width() return #tostring(vim.api.nvim_buf_line_count(0)) end

local function get_diagnostic_symbol(lnum)
  local diagnostics = vim.diagnostic.get(0, { lnum = lnum - 1 })
  if #diagnostics == 0 then return "   " end

  --- @type vim.diagnostic.Severity
  local max_severity = vim.diagnostic.severity.HINT

  for _, d in ipairs(diagnostics) do
    if d.severity < max_severity then max_severity = d.severity end
  end

  local diagnostic_symbols = {
    [vim.diagnostic.severity.ERROR] = { icon = Symbols.nf.cod_error, hl = "DiagnosticError" },
    [vim.diagnostic.severity.WARN] = { icon = Symbols.nf.cod_warning, hl = "DiagnosticWarn" },
    [vim.diagnostic.severity.INFO] = { icon = Symbols.nf.cod_info, hl = "DiagnosticInfo" },
    [vim.diagnostic.severity.HINT] = { icon = Symbols.nf.cod_question, hl = "DiagnosticHint" },
  }

  local diagnostic = diagnostic_symbols[max_severity]
  if diagnostic then return string.format("%%#%s# %s %%*", diagnostic.hl, diagnostic.icon) end
  return "   "
end

M.get_text = function()
  local text = ""
  text = table.concat {
    get_diagnostic_symbol(vim.v.lnum),
    M.number(),
    M.git(),
  }
  return text
end

M.git = function()
  ---@diagnostic disable-next-line: undefined-field
  local data = _G.MiniDiff.get_buf_data() or {}
  local hunks = data.hunks or {}
  return string.format(" %s ", M.create_git_statuscolumn(hunks))
end

M.create_git_statuscolumn = function(hunks)
  local function get_line_info(line_num)
    local direct_hunk = nil
    local deletion_above = nil
    local deletion_below = nil

    for _, hunk in ipairs(hunks) do
      local hunk_start = hunk.buf_start
      local hunk_end = hunk.buf_start + hunk.buf_count - 1

      if line_num >= hunk_start and line_num <= hunk_end then
        direct_hunk = hunk
      elseif hunk.type == "delete" then
        if line_num == hunk.buf_start + 1 then
          deletion_above = hunk
        elseif line_num == hunk.buf_start then
          deletion_below = hunk
        end
      end
    end

    local is_between_deletions = false
    for i, hunk in ipairs(hunks) do
      if hunk.type == "delete" then
        for j = i + 1, #hunks do
          if hunks[j].type == "delete" and hunks[j].buf_start == hunk.buf_start + 1 then
            if line_num == hunk.buf_start + 1 then is_between_deletions = true end
          end
        end
      end
    end

    return direct_hunk, deletion_above, deletion_below, is_between_deletions
  end

  local line_num = vim.v.lnum
  local hunk, deletion_above, deletion_below, is_between_deletions = get_line_info(line_num)

  if is_between_deletions then
    local hl = hunk and hunk.type == "change" and "Changed" or "Removed"
    return string.format("%%#%s#%s%%*", hl, Symbols.unicode.box_drawings.heavy.right)
  elseif deletion_above then
    local hl = hunk and hunk.type == "change" and "Changed" or "Removed"
    return string.format("%%#%s#%s%%*", hl, Symbols.unicode.box_drawings.heavy.down_and_right)
  elseif deletion_below then
    local hl = hunk and hunk.type == "change" and "Changed" or "Removed"
    return string.format("%%#%s#%s%%*", hl, Symbols.unicode.box_drawings.heavy.up_and_right)
  elseif hunk and hunk.type ~= "delete" then
    local symbols = {
      add = { symbol = Symbols.unicode.box_drawings.heavy.vertical, hl = "Added" },
      change = { symbol = Symbols.unicode.box_drawings.heavy.vertical, hl = "Changed" },
    }
    local git_info = symbols[hunk.type]
    if git_info then return string.format("%%#%s#%s%%*", git_info.hl, git_info.symbol) end
  end

  return string.format("%s%%*", Symbols.unicode.box_drawings.light.vertical)
end

M.number = function()
  local line_number = vim.v.lnum
  local current_line = vim.api.nvim_win_get_cursor(0)[1]
  local width = get_line_number_width()

  if line_number == current_line then return string.format("%" .. width .. "d", line_number) end

  local relative = math.abs(line_number - current_line)
  if relative == 0 then relative = line_number end
  return string.format("%" .. width .. "d", relative)
end

M.setup = function() vim.o.statuscolumn = [[%!v:lua.require("custom.statuscolumn").get_text()]] end

return M
