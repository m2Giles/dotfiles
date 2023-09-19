return {
  {
    "L3MON4D3/LuaSnip",
    keys = function()
      return {}
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-omni",
      "quangnguyen30192/cmp-nvim-ultisnips",
      "SirVer/ultisnips",
    },
    opts = function(_, opts)
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local ultisnip = require("cmp_nvim_ultisnips.mappings")

      opts.sources = cmp.config.sources(vim.list_extend(opts.sources, {
        { name = "omni" },
        { name = "ultisnips" },
      }))

      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.confirm({ select = true })
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          else
            ultisnip.expand_or_jump_forwards(fallback)
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            ultisnip.jump_backwards(fallback)
          end
        end, { "i", "s" }),
      })
    end,
  },
}
