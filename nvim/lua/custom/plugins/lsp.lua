local Util = require "custom.util"
local Symbols = require "custom.symbols"

local progress = vim.defaulttable()

local function on_lsp_progress(event)
  local client = vim.lsp.get_client_by_id(event.data.client_id)
  local value = event.data.params.value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
  if not client or type(value) ~= "table" then return end
  local p = progress[client.id]

  for i = 1, #p + 1 do
    if i == #p + 1 or p[i].token == event.data.params.token then
      p[i] = {
        token = event.data.params.token,
        msg = ("[%3d%%] %s%s"):format(
          value.kind == "end" and 100 or value.percentage or 100,
          value.title or "",
          value.message and (" **%s**"):format(value.message) or ""
        ),
        done = value.kind == "end",
      }
      break
    end
  end

  local msg = {} ---@type string[]
  progress[client.id] = vim.tbl_filter(
    function(v) return table.insert(msg, v.msg) or not v.done end,
    p
  )

  local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
  vim.notify(table.concat(msg, "\n"), vim.log.levels.INFO, {
    id = "lsp_progress",
    title = client.name,
    opts = function(notif)
      notif.icon = #progress[client.id] == 0 and " "
        or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
    end,
  })
end

return {
  "neovim/nvim-lspconfig",
  event = { "BufEnter" },
  config = function()
    vim.api.nvim_create_autocmd("LspProgress", {
      callback = on_lsp_progress,
    })

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("LspAttach", { clear = true }),
      callback = function(event)
        local diagnostic_signs = {
          [vim.diagnostic.severity.ERROR] = Symbols.nf.cod_error,
          [vim.diagnostic.severity.WARN] = Symbols.nf.cod_warning,
          [vim.diagnostic.severity.HINT] = Symbols.nf.cod_lightbulb,
          [vim.diagnostic.severity.INFO] = Symbols.nf.cod_info,
        }
        vim.diagnostic.config {
          severity_sort = true,
          signs = {
            text = diagnostic_signs,
          },
          underline = { severity = { vim.diagnostic.severity.ERROR, vim.diagnostic.severity.WARN } },
          virtual_text = {
            source = false, -- handled by format
            prefix = function(diagnostic, i, total)
              if i ~= total then return "" end
              return diagnostic_signs[diagnostic.severity] .. " "
            end,
          },
        }

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
        map("<Leader>d", vim.diagnostic.open_float)

        local client = vim.lsp.get_client_by_id(event.data.client_id)

        if client and client.name ~= "efm" then
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
        end

        if
          client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight)
        then
          local highlight_augroup = vim.api.nvim_create_augroup("LspHighlight", { clear = false })
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
        end

        if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_formatting) then
          vim.api.nvim_create_autocmd("BufWritePost", {
            group = vim.api.nvim_create_augroup("LspAutoformat", { clear = true }),
            callback = function() vim.lsp.buf.format { async = false } end,
          })
        end

        vim.api.nvim_create_autocmd("LspDetach", {
          group = vim.api.nvim_create_augroup("LspDetach", { clear = true }),
          callback = function(event2)
            vim.lsp.buf.clear_references()
            vim.api.nvim_clear_autocmds { group = "LspHighlight", buffer = event2.buf }
            vim.api.nvim_clear_autocmds { group = "LspAutoformat", buffer = event2.buf }
          end,
        })
      end,
    })

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)

    local servers = {
      lua_ls = {
        Lua = {
          runtime = {
            version = "LuaJIT",
          },
          workspace = {
            ignoreDir = { ".direnv" },
          },
        },
      },
      nil_ls = {},
      ts_ls = {},
      yamlls = {},
      taplo = {},
      html = {},
      cssls = {},
      jsonls = {},
      eslint = {},
      volar = {},
      rust_analyzer = {},
    }

    for server, settings in pairs(servers) do
      require("lspconfig")[server].setup {
        settings = settings,
        init_options = { documentFormatting = false },
        capabilities = capabilities,
      }
    end

    require("lspconfig").efm.setup {
      capabilities = capabilities,
    }
  end,
}
