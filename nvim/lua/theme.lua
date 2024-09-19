-- Colorscheme generated by https://github.com/arcticlimer/djanho
vim.cmd [[highlight clear]]

local highlight = function(group, bg, fg, attr)
  fg = fg and "guifg=" .. fg or ""
  bg = bg and "guibg=" .. bg or ""
  attr = attr and "gui=" .. attr or ""

  vim.api.nvim_command("highlight " .. group .. " " .. fg .. " " .. bg .. " " .. attr)
end

local link = function(target, group)
  vim.api.nvim_command("highlight! link " .. target .. " " .. group)
end

local Color9 = "#231919"
local Color2 = "#FF8080"
local Color5 = "#99FFE4"
local Color1 = "#FFF"
local Color6 = "#101010"
local Color7 = "#161616"
local Color0 = "#575757"
local Color10 = "#323232"
local Color8 = "#1b2321"
local Color3 = "#A0A0A0"
local Color4 = "#FFC799"
local Color11 = "#505050"

highlight("Comment", nil, Color0, nil)
highlight("Identifier", nil, Color1, nil)
highlight("Error", nil, Color2, nil)
highlight("Keyword", nil, Color3, nil)
highlight("Conditional", nil, Color3, nil)
highlight("Repeat", nil, Color3, nil)
highlight("Function", nil, Color4, nil)
highlight("Number", nil, Color4, nil)
highlight("TSCharacter", nil, Color4, nil)
highlight("String", nil, Color5, nil)
highlight("StatusLine", Color3, Color6, nil)
highlight("WildMenu", Color6, Color1, nil)
highlight("Pmenu", Color6, Color1, nil)
highlight("PmenuSel", Color1, Color7, nil)
highlight("PmenuThumb", Color6, Color1, nil)
highlight("DiffAdd", Color8, nil, nil)
highlight("DiffDelete", Color9, nil, nil)
highlight("Normal", Color6, Color1, nil)
highlight("Visual", Color10, nil, nil)
highlight("CursorLine", Color10, nil, nil)
highlight("ColorColumn", Color10, nil, nil)
highlight("SignColumn", Color6, nil, nil)
highlight("LineNr", nil, Color11, nil)
highlight("TabLine", Color6, nil, nil)
highlight("TabLineSel", nil, Color7, nil)
highlight("TabLineFill", Color6, nil, nil)
highlight("TSPunctDelimiter", nil, Color1, nil)

link("TSTagDelimiter", "Type")
link("TSKeyword", "Keyword")
link("TSConstBuiltin", "TSVariableBuiltin")
link("TSField", "Constant")
link("TSFunction", "Function")
link("TSConditional", "Conditional")
link("Repeat", "Conditional")
link("TSType", "Type")
link("TSString", "String")
link("TSParameter", "Constant")
link("TSPunctSpecial", "TSPunctDelimiter")
link("TSOperator", "Operator")
link("TSConstant", "Constant")
link("TSComment", "Comment")
link("NonText", "Comment")
link("TSRepeat", "Repeat")
link("Folded", "Comment")
link("TSTag", "MyTag")
link("TSNamespace", "TSType")
link("TSNumber", "Number")
link("TSLabel", "Type")
link("TSFloat", "Number")
link("TSFuncMacro", "Macro")
link("TSParameterReference", "TSParameter")
link("TSPunctBracket", "MyTag")
link("TelescopeNormal", "Normal")
link("Whitespace", "Comment")
link("Macro", "Function")
link("Operator", "Keyword")
link("Conditional", "Operator")
link("CursorLineNr", "Identifier")
link("TSProperty", "TSField")
