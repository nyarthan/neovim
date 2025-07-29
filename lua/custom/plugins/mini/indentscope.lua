return {
  "echasnovski/mini.indentscope",
  event = "BufEnter",
  opts = function()
    local indentscope = require "mini.indentscope"
    return {
      draw = {
        delay = 0,
        animation = indentscope.gen_animation.none(),
      },
    }
  end,
}
