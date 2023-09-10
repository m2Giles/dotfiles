return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    ensure_installed,
    {
      "bash",
      "c",
      "html",
      "json",
      "lua",
      "markdown",
      "markdown_inline",
      "python",
      "query",
      "regex",
      "vim",
      "vimdoc",
      "yaml",
    },
    highlight = {
      disable,
      {
        "latex",
        "tex",
      },
      additional_vim_regex_highlighting,
      {
        "latex",
        "tex",
      },
    },
  },
}
