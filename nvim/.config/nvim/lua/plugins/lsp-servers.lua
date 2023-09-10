-- LSPs to Install by Default

return
{
  "williamboman/mason.nvim",
  opts = {
    ensure_installed = {
      "bash-language-server",
      "bibtex-tidy",
      "black",
      "clangd",
      "clang-format",
      "latexindent",
      "ltex-ls",
      "lua_ls",
      "pyright",
      "stylua",
      "shellcheck",
      "texlab",
      "vale",
    },
  },
}
