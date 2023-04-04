-- nvim-cmp setup
local cmp = require 'cmp'
local luasnip = require 'luasnip'
local lspkind = require 'lspkind'

luasnip.config.setup {}

cmp.setup {
  completion = {
    completeopt = 'menu,menuone,noinsert',
  },
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  preselect = cmp.PreselectMode.Item,
  mapping = cmp.mapping.preset.insert {
    ['<C-k>'] = cmp.mapping.select_prev_item(), -- previous suggestion
    ['<C-j>'] = cmp.mapping.select_next_item(), -- next suggestion
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(), -- show completion suggestions
    ['<C-e>'] = cmp.mapping.abort(), -- close completion window
    ['<CR>'] = cmp.mapping.confirm { select = true },
  },
  -- sources for autocompletion
  sources = cmp.config.sources {
    { name = 'nvim_lsp' }, -- lsp
    { name = 'luasnip' }, -- snippets
    { name = 'buffer' }, -- text within current buffer
    { name = 'path' }, -- file system paths
  },
  -- configure lspkind for vs-code like icons
  -- configure lspkind for vs-code like icons
  formatting = {
    format = lspkind.cmp_format {
      maxwidth = 50,
      ellipsis_char = '...',
    },
  },
}
