return {
  config = function()
    local indentscope = require "mini.indentscope"
    return {
      draw = {
        delay = 0,
        animation = indentscope.gen_animation.none(),
      },
    }
  end,
}
