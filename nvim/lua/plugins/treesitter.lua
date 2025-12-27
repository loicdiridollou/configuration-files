-- import nvim-treesitter plugin safely
local status, treesitter = pcall(require, "nvim-treesitter")
if not status then
	return
end

treesitter.setup({
	-- Directory to install parsers and queries to (prepended to `runtimepath` to have priority)
	install_dir = vim.fn.stdpath("data") .. "/site",
})

-- Install your required parsers
treesitter.install({
	"json",
	"python",
	"go",
	"yaml",
	"markdown",
	"graphql",
	"bash",
	"javascript",
	"typescript",
	"lua",
	"vim",
	"rust",
	"toml",
	"dockerfile",
	"gitignore",
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = {
		"json",
		"python",
		"go",
		"yaml",
		"markdown",
		"graphql",
		"bash",
		"javascript",
		"typescript",
		"lua",
		"vim",
		"rust",
		"toml",
		"dockerfile",
		"gitignore",
	},
	callback = function()
		vim.treesitter.start()
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = {
		"json",
		"go",
		"yaml",
		"markdown",
		"graphql",
		"bash",
		"javascript",
		"typescript",
		"lua",
		"vim",
		"rust",
		"toml",
		"dockerfile",
		"gitignore",
	},
	callback = function()
		vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	end,
})
