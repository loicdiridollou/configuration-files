local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end

vim.opt.rtp:prepend(lazypath)

local plugins = {
	"nvim-tree/nvim-web-devicons",
	"nvim-lua/plenary.nvim", -- lua functions that many plugins use

	-- theme
	-- { "rose-pine/neovim", as = "rose-pine" },
	{ "catppuccin/nvim", as = "catppuccin" },

	"christoomey/vim-tmux-navigator", -- tmux & split window navigation

	"szw/vim-maximizer", -- maximizes and restores current window

	{
		"nvim-treesitter/nvim-treesitter",
		run = function()
			local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
			ts_update()
		end,
	},

	-- nvim-tree
	"nvim-tree/nvim-tree.lua",

	-- essential plugins
	"tpope/vim-surround", -- add, delete, change surroundings (it's awesome)
	"vim-scripts/ReplaceWithRegister", -- replace with register contents using motion (gr + motion)

	-- commenting with gc
	"numToStr/Comment.nvim",

	-- statusline
	"nvim-lualine/lualine.nvim",

	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
			config = function()
				require("telescope").load_extension("fzf")
			end,
		},
	},

	-- autocompletion
	"hrsh7th/nvim-cmp", -- completion plugin
	"hrsh7th/cmp-buffer", -- source for text in buffer
	"hrsh7th/cmp-path", -- source for file system paths

	-- snippets
	"L3MON4D3/LuaSnip", -- snippet engine
	"saadparwaiz1/cmp_luasnip", -- for autocompletion
	"rafamadriz/friendly-snippets", -- useful snippets

	-- managing & installing lsp servers, linters & formatters
	"williamboman/mason.nvim", -- in charge of managing lsp servers, linters & formatters
	"williamboman/mason-lspconfig.nvim", -- bridges gap b/w mason & lspconfig

	-- configuring lsp servers
	"neovim/nvim-lspconfig", -- easily configure language servers
	"hrsh7th/cmp-nvim-lsp", -- for autocompletion
	"onsails/lspkind.nvim", -- vs-code like icons for autocompletion

	-- formatting & linting
	"nvimtools/none-ls.nvim", -- configure formatters & linters
	"jayp0521/mason-null-ls.nvim", -- bridges gap b/w mason & null-ls

	-- git integration
	"lewis6991/gitsigns.nvim", -- show line modifications on left hand side
	"tpope/vim-fugitive",

	-- go support
	"ray-x/go.nvim",

	-- typescript
	"jose-elias-alvarez/typescript.nvim",

	{
		"rust-lang/rust.vim",
		ft = "rust",
		init = function()
			vim.g.rustfmt_autosave = 1
		end,
	},
}

local opts = {}

require("lazy").setup(plugins, opts)
