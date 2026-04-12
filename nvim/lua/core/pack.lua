-- Use a helper to shorten GitHub URLs
local gh = function(x)
	return "https://github.com/" .. x
end

-- NOTE: After first launch, plugins are cloned automatically.
-- Two plugins require a manual build step after install:
--   - nvim-treesitter: run :TSUpdate (or managed via treesitter.install())
--   - telescope-fzf-native.nvim: cd into its pack directory and run `make`
--     Path: ~/.local/share/nvim/site/pack/core/opt/telescope-fzf-native.nvim

vim.pack.add({
	-- icons (shared dependency)
	gh("nvim-tree/nvim-web-devicons"),
	-- lua utility library (shared dependency)
	gh("nvim-lua/plenary.nvim"),

	-- colorscheme
	gh("navarasu/onedark.nvim"),

	-- tmux & split window navigation
	gh("christoomey/vim-tmux-navigator"),
	-- maximize/restore current window
	gh("szw/vim-maximizer"),

	-- syntax highlighting & parsing
	gh("nvim-treesitter/nvim-treesitter"),

	-- file explorer
	gh("nvim-tree/nvim-tree.lua"),

	-- editing utilities
	gh("tpope/vim-surround"),
	gh("vim-scripts/ReplaceWithRegister"),
	gh("windwp/nvim-autopairs"),

	-- commenting (gc)
	gh("numToStr/Comment.nvim"),

	-- statusline
	gh("nvim-lualine/lualine.nvim"),

	-- fuzzy finder
	gh("nvim-telescope/telescope.nvim"),
	gh("nvim-telescope/telescope-fzf-native.nvim"), -- requires: cd into dir && make

	-- formatting
	gh("stevearc/conform.nvim"),

	-- autocompletion
	gh("hrsh7th/nvim-cmp"),
	gh("hrsh7th/cmp-buffer"),
	gh("hrsh7th/cmp-path"),

	-- snippets
	gh("L3MON4D3/LuaSnip"),
	gh("saadparwaiz1/cmp_luasnip"),
	gh("rafamadriz/friendly-snippets"),

	-- LSP: install & manage servers
	gh("williamboman/mason.nvim"),
	gh("williamboman/mason-lspconfig.nvim"),

	-- LSP: configuration
	gh("neovim/nvim-lspconfig"),
	gh("hrsh7th/cmp-nvim-lsp"),
	gh("onsails/lspkind.nvim"),

	-- linting/formatting via none-ls
	gh("nvimtools/none-ls.nvim"),
	gh("jayp0521/mason-null-ls.nvim"),

	-- git
	gh("lewis6991/gitsigns.nvim"),
	gh("tpope/vim-fugitive"),

	-- TypeScript
	gh("pmizio/typescript-tools.nvim"),

	-- Go
	gh("ray-x/guihua.lua"), -- UI dependency for go.nvim
	gh("ray-x/go.nvim"),

	-- Rust
	gh("rust-lang/rust.vim"),
})
