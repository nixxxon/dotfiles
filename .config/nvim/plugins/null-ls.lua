return {
  "jose-elias-alvarez/null-ls.nvim",
  opts = function(_, config)
    -- config variable is the default configuration table for the setup function call
    local null_ls = require "null-ls"

    local lsp_formatting = function(bufnr)
      vim.lsp.buf.format {
        filter = function(client) return client.name == "null-ls" end,
        bufnr = bufnr,
        timeout_ms = 10000,
      }
    end

    config.sources = {
      null_ls.builtins.formatting.prettier.with {
        only_local = "node_modules/.bin",
      },
    }

    local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
    config.on_attach = function(client, buffer)
      if not buffer then return end
      if not client.server_capabilities.documentFormattingProvider then return end

      vim.api.nvim_clear_autocmds { group = augroup, buffer = buffer }
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = buffer,
        callback = function() lsp_formatting(buffer) end,
      })
    end
    config.debug = true
    return config -- return final config table
  end,
}
