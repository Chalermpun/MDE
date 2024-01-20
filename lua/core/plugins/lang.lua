return {
	--BibTeX/LaTeX
	{
		"lervag/vimtex",
		lazy = false, -- lazy-loading will disable inverse search
		config = function()
			vim.api.nvim_create_autocmd({ "FileType" }, {
				group = vim.api.nvim_create_augroup("lazyvim_vimtex_conceal", { clear = true }),
				pattern = { "bib", "tex" },
				callback = function()
					vim.wo.conceallevel = 2
				end,
			})

			vim.g.vimtex_mappings_disable = { ["n"] = { "K" } } -- disable `K` as it conflicts with LSP hover
			vim.g.vimtex_quickfix_method = vim.fn.executable("pplatex") == 1 and "pplatex" or "latexlog"
		end,
	},

	"jbyuki/nabla.nvim",

	-- yaml schema support
	{
		"b0o/SchemaStore.nvim",
		lazy = true,
		version = false, -- last release is way too old
	},

	-- Markdown preview
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
		keys = {
			{
				"<leader>cp",
				ft = "markdown",
				"<cmd>MarkdownPreviewToggle<cr>",
				desc = "Markdown Preview",
			},
		},
		config = function()
			vim.cmd([[do FileType]])
		end,
	},

	{
		"lukas-reineke/headlines.nvim",
		opts = function()
			local opts = {}
			for _, ft in ipairs({ "markdown", "norg", "rmd", "org" }) do
				opts[ft] = {
					headline_highlights = {},
					codeblock_highlight = "CodeBlock",
					dash_highlight = "Dash",
					dash_string = "-",
					quote_highlight = "Quote",
					quote_string = "┃",
					fat_headlines = true,
					fat_headline_upper_string = "▃",
					fat_headline_lower_string = "󰕱",
				}
				for i = 1, 6 do
					local hl = "Headline" .. i
					vim.api.nvim_set_hl(0, hl, { link = "Headline", default = true })
					table.insert(opts[ft].headline_highlights, hl)
				end
			end
			return opts
		end,
		ft = { "markdown", "norg", "rmd", "org" },
		config = function(_, opts)
			-- PERF: schedule to prevent headlines slowing down opening a file
			vim.schedule(function()
				require("headlines").setup(opts)
				require("headlines").refresh()
			end)
		end,
	},

	{
		"AckslD/nvim-FeMaco.lua",
		config = 'require("femaco").setup()',
	},

	{
		"dhruvasagar/vim-table-mode",
		ft = { "markdown", "org", "norg" },
	},

	{
		"mzlogin/vim-markdown-toc",
		ft = { "markdown" },
	},

	{
		-- "numiras/semshi",
		"wookayin/semshi", -- use a maintained fork
		ft = "python",
		build = ":UpdateRemotePlugins",
		event = "VeryLazy",
		init = function()
			-- Disabled these features better provided by LSP or other more general plugins
			vim.g["semshi#error_sign"] = false
			vim.g["semshi#simplify_markup"] = false
			vim.g["semshi#mark_selected_nodes"] = false
			vim.g["semshi#update_delay_factor"] = 0.001

			-- This autocmd must be defined in init to take effect
			vim.api.nvim_create_autocmd({ "VimEnter", "ColorScheme" }, {
				group = vim.api.nvim_create_augroup("SemanticHighlight", {}),
				callback = function()
					-- Only add style, inherit or link to the LSP's colors
					vim.cmd([[
            highlight! semshiGlobal gui=italic
            highlight! link semshiImported @none
            highlight! link semshiParameter @lsp.type.parameter
            highlight! link semshiParameterUnused DiagnosticUnnecessary
            highlight! link semshiBuiltin @function.builtin
            highlight! link semshiAttribute @field
            highlight! link semshiSelf @lsp.type.selfKeyword
            highlight! link semshiUnresolved @lsp.type.unresolvedReference
            highlight! link semshiFree @none
            ]])
				end,
			})
		end,
	},

	{
		"linux-cultist/venv-selector.nvim",
		event = "VeryLazy",
		cmd = "VenvSelect",
		opts = function(_, opts)
			if require("core.util").has("nvim-dap-python") then
				opts.dap_enabled = true
			end
			return vim.tbl_deep_extend("force", opts, {
				name = {
					"venv",
					".venv",
					"env",
					".env",
				},
			})
		end,
		keys = { { "<leader>cv", "<cmd>:VenvSelect<cr>", desc = "Select VirtualEnv" } },
	},

	-- yaml schema support
	{
		"b0o/SchemaStore.nvim",
		lazy = true,
		version = false, -- last release is way too old
	},
}
