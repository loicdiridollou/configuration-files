-- import null-ls plugin safely
local setup, null_ls = pcall(require, "null-ls")
if not setup then
	return
end

-- for conciseness
local formatting = null_ls.builtins.formatting -- to setup formatters
local diagnostics = null_ls.builtins.diagnostics -- to setup linters

-- to setup format on save
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

-- configure null_ls
null_ls.setup({
	-- setup formatters & linters
	sources = {
		--  to disable file types use
		formatting.prettier,
		formatting.stylua, -- lua formatter
		formatting.black,
		formatting.isort,
		formatting.gofumpt,
		formatting.golines,
		diagnostics.ruff.with({
			extra_args = {
				"--line-length",
				"88",
				"--select",
				"A,B,C,D,E,F,I,UP",
				"--ignore",
				"D107,D203,D212,D213,D402,D413,D415,D416,D417",
			},
		}),
		diagnostics.flake8.with({ extra_args = { "--max-line-length", "88" } }),
	},
	-- configure format on save
	on_attach = function(current_client, bufnr)
		if current_client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					vim.lsp.buf.format({
						filter = function(client)
							--  only use null-ls for formatting instead of lsp server
							return client.name == "null-ls"
						end,
						bufnr = bufnr,
					})
				end,
			})
		end
	end,
})
