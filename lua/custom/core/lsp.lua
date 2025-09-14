local FILETYPES = {
  javascriptLike = {
    "javascript",
    "javascriptReact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.jsx",
  },
  jsonLike = {
    "json",
    "jsonc",
  },
  yaml = {
    "yaml",
    "yml",
  },
}

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)

vim.lsp.config("*", {
  capabilities = capabilities,
  init_options = { hostInfo = "neovim" },
  root_markers = {
    ".git/",
  },
})

vim.lsp.config("ts_ls", {
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = FILETYPES.javascriptLike,
  root_markers = {
    ".git/",
    "pnpm-lock.yaml",
    "yarn.lock",
    "deno.lock",
    "bun.lock",
    "bun.lockb",
  },
})

vim.lsp.config("jsonls", {
  cmd = { "vscode-json-language-server", "--stdio" },
  filetypes = FILETYPES.jsonLike,
  settings = {
    json = {
      schemas = {
        { url = "https://www.schemastore.org/package.json", fileMatch = { "package.json" } },
      },
    },
  },
})

vim.lsp.config("yamlls", {
  cmd = { "yaml-language-server", "--stdio" },
  filetypes = FILETYPES.yaml,
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
})

vim.lsp.config("nixd", {
  cmd = { "nixd" },
  filetypes = { "nix" },
  root_markers = {
    ".git/",
    "flake.lock",
  },
})

vim.lsp.config("lua_ls", {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  on_init = function(client)
    if client.workspace_folders then
      local path = client.workspace_folders[1].name
      if
        path ~= vim.fn.stdpath "config"
        and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
      then
        return
      end
    end

    client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
      runtime = {
        version = "LuaJIT",
        path = {
          "lua/?.lua",
          "lua/?/init.lua",
        },
      },
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
        },
      },
    })
  end,
  settings = {
	  Lua = {}
  }
})

local lsp = vim.lsp

local eslint_config_files = {}

vim.lsp.config("eslint", {
  cmd = { "vscode-eslint-language-server", "--stdio" },
  filetypes = FILETYPES.javascriptLike,
  settings = {
    nodePath = "",
    experimental = {
      useFlatConfig = true,
    },
  },
  workspace_required = true,
  root_markers = {
    {
      ".eslintrc",
      ".eslintrc.js",
      ".eslintrc.cjs",
      ".eslintrc.yaml",
      ".eslintrc.yml",
      ".eslintrc.json",
      "eslint.config.js",
      "eslint.config.mjs",
      "eslint.config.cjs",
      "eslint.config.ts",
      "eslint.config.mts",
      "eslint.config.cts",
    },
    { ".git/", "package.json" },
  },
})

vim.lsp.enable "ts_ls"
vim.lsp.enable "jsonls"
vim.lsp.enable "yamlls"
vim.lsp.enable "nixd"
vim.lsp.enable "lua_ls"
vim.lsp.enable "eslint"
