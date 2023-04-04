-- enable mason
require('mason').setup()

require('mason-lspconfig').setup {
  -- list of servers for mason to install
  ensure_installed = {
    'pyright',
    'gopls',
    'lua_ls',
  },
  -- auto-install configured servers (with lspconfig)
  automatic_installation = true, -- not the same as ensure_installed
}

require('mason-null-ls').setup {
  -- list of formatters & linters for mason to install
  ensure_installed = {
    'prettier', -- ts/js formatter
    'stylua', -- lua formatter
    'black',
    'gopls',
    'flake8',
  },
  -- auto-install configured formatters & linters (with null-ls)
  automatic_installation = true,
}
