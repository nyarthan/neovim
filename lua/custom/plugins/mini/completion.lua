return {
  config = function()
    require("mini.completion").setup {
      lsp_completion = { source_func = "omnifunc", auto_setup = false },
    }

    local on_attach = function(args)
      print(vim.inspect(args))
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      client.server_capabilities.semanticTokensProvider = nil
      vim.bo[args.buf].omnifunc = "v:lua.MiniCompletion.completefunc_lsp"
    end
    vim.api.nvim_create_autocmd("LspAttach", {
      pattern = "*",
      callback = on_attach,
    })
    local capabilities = vim.tbl_deep_extend(
      "force",
      vim.lsp.protocol.make_client_capabilities(),
      MiniCompletion.get_lsp_capabilities { resolve_additional_text_edits = false }
    )

    capabilities.textDocument.formatting = nil
    capabilities.textDocument.rangeFormatting = nil

    vim.lsp.config("*", {
      capabilities = capabilities,
      init_options = { hostInfo = "neovim" },
      root_markers = {
        ".git/",
      },
    })
  end,
}
