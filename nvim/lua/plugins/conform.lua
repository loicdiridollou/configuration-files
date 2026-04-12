local status, conform = pcall(require, "conform")
if not status then
	return
end

vim.keymap.set("", "<leader>f", function()
	conform.format({ async = true, lsp_format = "fallback" })
end, { desc = "[F]ormat buffer" })

conform.setup({
	notify_on_error = false,
	format_on_save = function(bufnr)
		local disable_filetypes = { c = true, cpp = true }
		if disable_filetypes[vim.bo[bufnr].filetype] then
			return nil
		else
			return {
				timeout_ms = 1500,
				lsp_format = "fallback",
			}
		end
	end,
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "isort", "black" },
		go = { "gofumpt", "golines" },
		javascript = { "prettierd", "prettier", stop_after_first = true },
		typescript = { "prettierd", "prettier", stop_after_first = true },
		markdown = { "prettier" },
	},
	formatters = {
		prettier = {
			prepend_args = { "--print-width", "80", "--prose-wrap", "always" },
		},
	},
})
