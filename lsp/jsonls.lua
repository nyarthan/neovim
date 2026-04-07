---@type vim.lsp.Config
return {
  cmd = { "vscode-json-language-server", "--stdio" },
  filetypes = { "json", "jsonc" },
  settings = {
    json = {
      schemas = {
        { url = "https://www.schemastore.org/package.json", fileMatch = { "package.json" } },
        {
          url = "https://www.schemastore.org/tsconfig.json",
          fileMatch = { "tsconfig.json", "tsconfig.*.json" },
        },
        { url = "https://turborepo.dev/schema.json", fileMatch = { "turbo.json", "turbo.jsonc" } },
      },
    },
  },
}
