return {
  "pmizio/typescript-tools.nvim",
  dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
  ft = {
    "typescript",
    "typescriptReact",
    "typescript.jsx",
    "javascript",
    "javascriptReact",
    "javascript.jsx",
    "vue",
  },
  opts = {
    settings = {
      tsserver_plugins = {
        "/nix/store/582wpl6ml9rin36ilzzi4srahmf9c3kq-vue-language-server-2.2.8/lib/node_modules/@vue/language-server",
      },
    },
  },
}
