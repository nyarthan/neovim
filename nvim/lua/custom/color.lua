local M = {}

M.ansi = {
  -- Text colors
  black = "\27[30m",
  red = "\27[31m",
  green = "\27[32m",
  yellow = "\27[33m",
  blue = "\27[34m",
  magenta = "\27[35m",
  cyan = "\27[36m",
  white = "\27[37m",

  -- Bright text colors
  bright_black = "\27[90m",
  bright_red = "\27[91m",
  bright_green = "\27[92m",
  bright_yellow = "\27[93m",
  bright_blue = "\27[94m",
  bright_magenta = "\27[95m",
  bright_cyan = "\27[96m",
  bright_white = "\27[97m",

  -- Background colors
  bg_black = "\27[40m",
  bg_red = "\27[41m",
  bg_green = "\27[42m",
  bg_yellow = "\27[43m",
  bg_blue = "\27[44m",
  bg_magenta = "\27[45m",
  bg_cyan = "\27[46m",
  bg_white = "\27[47m",

  -- Bright background colors
  bg_bright_black = "\27[100m",
  bg_bright_red = "\27[101m",
  bg_bright_green = "\27[102m",
  bg_bright_yellow = "\27[103m",
  bg_bright_blue = "\27[104m",
  bg_bright_magenta = "\27[105m",
  bg_bright_cyan = "\27[106m",
  bg_bright_white = "\27[107m",

  -- Styles
  bold = "\27[1m",
  dim = "\27[2m",
  italic = "\27[3m",
  underline = "\27[4m",
  blink = "\27[5m",
  reverse = "\27[7m",
  hidden = "\27[8m",
  strikethrough = "\27[9m",

  -- Reset
  reset = "\27[0m",
}

for name, code in pairs(M.ansi) do
  M[name] = function(str) return code .. str .. M.ansi.reset end
end

return M
