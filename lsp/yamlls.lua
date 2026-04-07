---@type vim.lsp.Config
return {
  cmd = { "yaml-language-server", "--stdio" },
  filetypes = { "yaml", "yml" },
  settings = {
    yaml = {
      redhat = {
        telemetry = {
          enabled = false,
        },
      },
      schemas = {
        {
          url = "https://www.schemastore.org/pnpm-workspace.json",
          fileMatch = { "pnpm-workspace.yaml" },
        },
        {
          url = "https://www.schemastore.org/github-workflow.json",
          fileMatch = { ".github/workflows/*.yaml", ".github/workflows/*.yml" },
        },
      },
    },
  },
}
