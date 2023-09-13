-- LSPs to Install by Default

return {
  "williamboman/mason.nvim",
  opts = function(_, opts)
    if type(opts.ensure_installed) == "table" then
      vim.list_extend(opts.ensure_installed, {
        "bash-language-server",
        "bibtex-tidy",
        "black",
        "clangd",
        "clang-format",
        "latexindent",
        "ltex-ls",
        "lua-language-server",
        "pyright",
        "stylua",
        "shellcheck",
        "texlab",
        "vale",
      })
    end
  end,
}
