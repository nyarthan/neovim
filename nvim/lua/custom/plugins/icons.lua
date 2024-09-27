return {
  "echasnovski/mini.icons",
  config = function()
    require("mini.icons").setup()

    _G.MiniIcons.mock_nvim_web_devicons()
  end,
}
