-- import lspconfig plugin safely
local lspconfig_status, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status then
	return
end

-- import cmp-nvim-lsp plugin safely
local cmp_nvim_lsp_status, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not cmp_nvim_lsp_status then
	return
end

local keymap = vim.keymap -- for conciseness

-- changing the size of the floating window to 80 chars or defined by user
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
	opts = opts or {}
	opts.border = opts.border or "single"
	opts.max_width = opts.max_width or 80
	return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

-- enable keybinds only for when lsp server available
local on_attach = function(client, bufnr)
	-- keybind options
	local opts = { noremap = true, silent = true, buffer = bufnr }

	-- set keybinds
	keymap.set("n", "gf", "<cmd>Lspsaga lsp_finder<CR>", opts) -- show definition, references
	keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts) -- got to declaration
	keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts) -- got to declaration
	keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts) -- go to implementation
	keymap.set("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts) -- see available code actions
	keymap.set("n", "<leader>rn", vim.lsp.buf.rename) -- smart rename
	keymap.set("n", "<leader>d", "<cmd>Lspsaga show_line_diagnostics<CR>", opts) -- show  diagnostics for line
	keymap.set("n", "<leader>d", "<cmd>Lspsaga show_cursor_diagnostics<CR>", opts) -- show diagnostics for cursor
	keymap.set("n", "[d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts) -- jump to previous diagnostic in buffer
	keymap.set("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts) -- jump to next diagnostic in buffer
	keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts) -- show documentation for what is under cursor
	keymap.set("n", "<leader>o", "<cmd>LSoutlineToggle<CR>", opts) -- see outline on right hand side

	-- typescript specific keymaps (e.g. rename file and update imports)
	if client.name == "tsserver" then
		keymap.set("n", "<leader>rf", ":TypescriptRenameFile<CR>") -- rename file and update imports
		keymap.set("n", "<leader>oi", ":TypescriptOrganizeImports<CR>") -- organize imports (not in youtube nvim video)
		keymap.set("n", "<leader>ru", ":TypescriptRemoveUnused<CR>") -- remove unused variables (not in youtube nvim video)
	end
end

-- used to enable autocompletion (assign to every lsp server config)
local capabilities = cmp_nvim_lsp.default_capabilities()

require("vim.lsp.protocol").CompletionItemKind = {
	"", -- Text
	"0", -- Method
	"0", -- Function
	"", -- Constructor
	"", -- Field
	"", -- Variable
	"", -- Class
	"ﰮ", -- Interface
	"", -- Module
	"", -- Property
	"", -- Unit
	"", -- Value
	"了", -- Enum
	"", -- Keyword
	"﬌", -- Snippet
	"", -- Color
	"", -- File
	"", -- Reference
	"", -- Folder
	"", -- EnumMember
	"", -- Constant
	"", -- Struct
	"", -- Event
	"ﬦ", -- Operator
	"", -- TypeParameter
}

-- Change the Diagnostic symbols in the sign column (gutter)
-- (not in youtube nvim video)
local signs = { Error = " ", Warn = " ", Hint = "ﴞ ", Info = " " }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-- configure gopls server
lspconfig["gopls"].setup({
	cmd = { "gopls" },
	settings = {
		gopls = {
			analyses = {
				nilness = true,
				unusedparams = true,
				unusedwrite = true,
				useany = true,
			},
			experimentalPostfixCompletions = true,
			gofumpt = true,
			staticcheck = true,
			usePlaceholders = true,
		},
	},
	on_attach = on_attach,
})

-- configure css server
lspconfig["pyright"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
	settings = {
		pyright = {
			analyses = {
				autoImportCompletion = true,
			},
		},
	},
})
lspconfig.diagnosticls.setup({
	filetypes = { "python" },
	init_options = {
		filetypes = {
			python = { "flake8", "pylint" },
		},
		linters = {
			flake8 = {
				debounce = 100,
				sourceName = "flake8",
				command = "flake8",
				args = {
					"--format",
					"%(row)d:%(col)d:%(code)s:%(code)s: %(text)s",
					"%file",
				},
				formatPattern = {
					"^(\\d+):(\\d+):(\\w+):(\\w).+: (.*)$",
					{
						line = 1,
						column = 2,
						message = { "[", 3, "] ", 5 },
						security = 4,
					},
				},
				securities = {
					E = "error",
					W = "warning",
					F = "info",
					B = "hint",
				},
			},
			pylint = {
				debounce = 100,
				sourceName = "pylint",
				command = "pylint",
				args = {
					"--format",
					"%(row)d:%(col)d:%(code)s:%(code)s: %(text)s",
					"%file",
				},
				formatPattern = {
					"^(\\d+):(\\d+):(\\w+):(\\w).+: (.*)$",
					{
						line = 1,
						column = 2,
						message = { "[", 3, "] ", 5 },
						security = 4,
					},
				},
				securities = {
					E = "error",
					W = "warning",
					F = "info",
					B = "hint",
				},
			},
		},
	},
})

-- configure tailwindcss server
lspconfig["tailwindcss"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

-- configure emmet language server
lspconfig["emmet_ls"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
	filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
})

-- configure lua server (with special settings)
lspconfig["lua_ls"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
	settings = { -- custom settings for lua
		Lua = {
			-- make the language server recognize "vim" global
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				-- make language server aware of runtime files
				library = {
					[vim.fn.expand("$VIMRUNTIME/lua")] = true,
					[vim.fn.stdpath("config") .. "/lua"] = true,
				},
			},
		},
	},
})
