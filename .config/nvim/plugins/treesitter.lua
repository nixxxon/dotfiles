return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    ensure_installed = {
      "lua",
      "javascript",
      "php",
      "phpdoc",
      "typescript",
      "hcl",
      "prisma",
      "graphql",
      "tsx",
      "json",
      "terraform",
    },
    highlight = {
      enable = true,
      use_languagetree = true,
    },
    indent = {
      enable = true,
    },
  },
}
