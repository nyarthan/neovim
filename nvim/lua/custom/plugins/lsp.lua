local Util = require "custom.util"

return {
  "neovim/nvim-lspconfig",
  event = "BufEnter",
  dependencies = {
    {
      "j-hui/fidget.nvim",
      opts = {
        integration = {
          ["nvim-tree"] = {
            enable = false,
          },
          ["xcodebuild-nvim"] = {
            enable = false,
          },
        },
      },
    },
    "hrsh7th/cmp-nvim-lsp",
  },
  config = function()
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
      callback = function(event)
        local t_builtin = require "telescope.builtin"

        local map = Util.make_map { mode = "n", buffer = event.buf }

        map("gd", t_builtin.lsp_definitions)
        map("gD", vim.lsp.buf.declaration)
        map("gr", t_builtin.lsp_references)
        map("gI", t_builtin.lsp_implementations)
        map("<Leader>gd", t_builtin.lsp_type_definitions)
        map("<Leader>gs", t_builtin.lsp_document_symbols)
        map("<Leader>gws", t_builtin.lsp_dynamic_workspace_symbols)
        map("<Leader>rn", vim.lsp.buf.rename)
        map("<Leader>ca", vim.lsp.buf.code_action, { mode = { "x" } })

        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if
          client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight)
        then
          local highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
          vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
          })

          vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
          })

          vim.api.nvim_create_autocmd("LspDetach", {
            group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
            callback = function(event2)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds { group = "lsp-highlight", buffer = event2.buf }
            end,
          })
        end

        if
          client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentSymbol)
        then
          require("nvim-navic").attach(client, event.buf)
        end
      end,
    })

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities =
      vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

    local servers = {
      "lua_ls",
    }

    for _, server in ipairs(servers) do
      require("lspconfig")[server].setup {
        init_options = { documentFormatting = false },
        capabilities = capabilities,
      }
    end

    require("lspconfig").efm.setup {
      capabilities = capabilities,
      init_options = { documentFormatting = true },
    }
  end,
}
