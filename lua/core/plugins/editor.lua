local Util = require("core.util")
local Config = require("core.config.util")
return {
	-- allow you to navigate seamlessly between vim and tmux splits using a consistent set of hotkeys
	"christoomey/vim-tmux-navigator",

	-- change the size of your current window.
	"anuvyklack/hydra.nvim",

	--allows all git file operations within neovim
	"tpope/vim-fugitive",

	-- A git blame plugin for see who commit the code
	"f-person/git-blame.nvim",

	--generate shareable file permalinks (with line ranges) for several git web frontend hosts.
	"ruifm/gitlinker.nvim",

	--gitignore generated
	"wintermute-cell/gitignore.nvim",

	-- git signs highlights text that has changed since the list
	-- git commit, and also lets you interactively stage & unstage
	-- hunks in a commit.
	{
		"lewis6991/gitsigns.nvim",
		event = "VeryLazy",
		opts = {
			signs = {
				change = { text = "▎" },
				delete = { text = "" },
				add = { text = "▎" },
				topdelete = { text = "" },
				changedelete = { text = "▎" },
				untracked = { text = "▎" },
			},
			on_attach = function(buffer)
				local gs = package.loaded.gitsigns

				local function map(mode, l, r, desc)
					vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
				end

        -- stylua: ignore start
        map("n", "]h", gs.next_hunk, "Next Hunk")
        map("n", "[h", gs.prev_hunk, "Prev Hunk")
        map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
        map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
        map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
        map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
        map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
        map("n", "<leader>ghp", gs.preview_hunk, "Preview Hunk")
        map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame Line")
        map("n", "<leader>ghd", gs.diffthis, "Diff This")
        map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff This ~")
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
			end,
		},
	},

	-- Single tabpage interface for easily cycling through diffs for all modified files for any git rev.
	{
		"sindrets/diffview.nvim",
		config = function()
			require("diffview").setup({
				win_config = { -- See ':h diffview-config-win_config'
					position = "left",
					width = 40,
					win_opts = {},
				},
			})
		end,
	},

	--git branch viewer
	{
		"rbong/vim-flog",
		lazy = true,
		cmd = { "Flog", "Flogsplit", "Floggit" },
		dependencies = {
			"tpope/vim-fugitive",
		},
	},

	-- Automatically highlights other instances of the word under your cursor.
	-- This works with LSP, Treesitter, and regexp matching to find the other
	-- instances.
	{
		"RRethy/vim-illuminate",
		event = "VeryLazy",
		opts = {
			delay = 200,
			large_file_cutoff = 2000,
			large_file_overrides = {
				providers = { "lsp" },
			},
		},
		config = function(_, opts)
			require("illuminate").configure(opts)

			local function map(key, dir, buffer)
				vim.keymap.set("n", key, function()
					require("illuminate")["goto_" .. dir .. "_reference"](false)
				end, { desc = dir:sub(1, 1):upper() .. dir:sub(2) .. " Reference", buffer = buffer })
			end

			map("]]", "next")
			map("[[", "prev")

			-- also set it after loading ftplugins, since a lot overwrite [[ and ]]
			vim.api.nvim_create_autocmd("FileType", {
				callback = function()
					local buffer = vim.api.nvim_get_current_buf()
					map("]]", "next", buffer)
					map("[[", "prev", buffer)
				end,
			})
		end,
		keys = {
			{ "]]", desc = "Next Reference" },
			{ "[[", desc = "Prev Reference" },
		},
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			plugins = { spelling = true },
			defaults = {
				mode = "n",
				["g"] = { name = "+goto" },
				["gs"] = { name = "+surround" },
				["]"] = { name = "+next" },
				["["] = { name = "+prev" },
				["<leader><tab>"] = { name = "+tabs" },
				["<leader>b"] = { name = "+buffer" },
				["<leader>c"] = { name = "+code" },
				["<leader>f"] = { name = "+file/find" },
				["<leader>g"] = { name = "+git" },
				["<leader>gh"] = { name = "+hunks" },
				["<leader>q"] = { name = "+quit/session" },
				["<leader>s"] = { name = "+search" },
				["<leader>u"] = { name = "+ui" },
				["<leader>w"] = { name = "+windows" },
				["<leader>x"] = { name = "+diagnostics/quickfix" },
				["<localLeader>l"] = { name = "+vimtex" },
				["<leader>d"] = { name = "+debug" },
			},
		},
		config = function(_, opts)
			local wk = require("which-key")
			wk.setup(opts)
			wk.register(opts.defaults)
		end,
	},
	-- Fuzzy finder.
	-- The default key bindings to find files will use Telescope's
	-- `find_files` or `git_files` depending on whether the
	-- directory is a git repo.
	{
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope",
		event = "VeryLazy",
		version = false, -- telescope did only one release, so use HEAD for now
		dependencies = {
			"kevinhwang91/nvim-bqf",
			{
				{ "nvim-lua/plenary.nvim", lazy = true },
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
				enabled = vim.fn.executable("make") == 1,
				config = function()
					Util.on_load("telescope.nvim", function()
						require("telescope").load_extension("fzf")
					end)
				end,
			},
			{
				"ahmedkhalf/project.nvim",
				opts = {
					manual_mode = true,
				},
				event = "VeryLazy",
				config = function(_, opts)
					require("project_nvim").setup(opts)
					require("core.util").on_load("telescope.nvim", function()
						require("telescope").load_extension("projects")
					end)
				end,
				keys = {
					{ "<leader>fp", "<Cmd>Telescope projects<CR>", desc = "Projects" },
				},
			},
		},
		keys = {
			{
				"<leader>,",
				"<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>",
				desc = "Switch Buffer",
			},
			{ "<leader>/", Util.telescope("live_grep"), desc = "Grep (root dir)" },
			{ "<leader>:", "<cmd>Telescope command_history<cr>", desc = "Command History" },
			{ "<leader><space>", Util.telescope("files"), desc = "Find Files (root dir)" },
			-- find
			{ "<leader>fb", "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>", desc = "Buffers" },
			{ "<leader>fc", Util.telescope.config_files(), desc = "Find Config File" },
			{ "<leader>ff", Util.telescope("files"), desc = "Find Files (root dir)" },
			{ "<leader>fF", Util.telescope("files", { cwd = false }), desc = "Find Files (cwd)" },
			{ "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent" },
			{ "<leader>fR", Util.telescope("oldfiles", { cwd = vim.loop.cwd() }), desc = "Recent (cwd)" },
			-- git
			{ "<leader>gc", "<cmd>Telescope git_commits<CR>", desc = "commits" },
			{ "<leader>gs", "<cmd>Telescope git_status<CR>", desc = "status" },
			-- search
			{ '<leader>s"', "<cmd>Telescope registers<cr>", desc = "Registers" },
			{ "<leader>sa", "<cmd>Telescope autocommands<cr>", desc = "Auto Commands" },
			{ "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Buffer" },
			{ "<leader>sc", "<cmd>Telescope command_history<cr>", desc = "Command History" },
			{ "<leader>sC", "<cmd>Telescope commands<cr>", desc = "Commands" },
			{ "<leader>sd", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "Document diagnostics" },
			{ "<leader>sD", "<cmd>Telescope diagnostics<cr>", desc = "Workspace diagnostics" },
			{ "<leader>sg", Util.telescope("live_grep"), desc = "Grep (root dir)" },
			{ "<leader>sG", Util.telescope("live_grep", { cwd = false }), desc = "Grep (cwd)" },
			{ "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Help Pages" },
			{ "<leader>sH", "<cmd>Telescope highlights<cr>", desc = "Search Highlight Groups" },
			{ "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Key Maps" },
			{ "<leader>sM", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },
			{ "<leader>sm", "<cmd>Telescope marks<cr>", desc = "Jump to Mark" },
			{ "<leader>so", "<cmd>Telescope vim_options<cr>", desc = "Options" },
			{ "<leader>sR", "<cmd>Telescope resume<cr>", desc = "Resume" },
			{ "<leader>sw", Util.telescope("grep_string", { word_match = "-w" }), desc = "Word (root dir)" },
			{ "<leader>sW", Util.telescope("grep_string", { cwd = false, word_match = "-w" }), desc = "Word (cwd)" },
			{ "<leader>sw", Util.telescope("grep_string"), mode = "v", desc = "Selection (root dir)" },
			{ "<leader>sW", Util.telescope("grep_string", { cwd = false }), mode = "v", desc = "Selection (cwd)" },
			{
				"<leader>uC",
				Util.telescope("colorscheme", { enable_preview = true }),
				desc = "Colorscheme with preview",
			},
			{
				"<leader>ss",
				function()
					require("telescope.builtin").lsp_document_symbols({
						symbols = require("core.config.util").get_kind_filter(),
					})
				end,
				desc = "Goto Symbol",
			},
			{
				"<leader>sS",
				function()
					require("telescope.builtin").lsp_dynamic_workspace_symbols({
						symbols = require("core.config.util").get_kind_filter(),
					})
				end,
				desc = "Goto Symbol (Workspace)",
			},
		},
		opts = function()
			local actions = require("telescope.actions")

			local open_with_trouble = function(...)
				return require("trouble.providers.telescope").open_with_trouble(...)
			end
			local open_selected_with_trouble = function(...)
				return require("trouble.providers.telescope").open_selected_with_trouble(...)
			end
			local find_files_no_ignore = function()
				local action_state = require("telescope.actions.state")
				local line = action_state.get_current_line()
				Util.telescope("find_files", { no_ignore = true, default_text = line })()
			end
			local find_files_with_hidden = function()
				local action_state = require("telescope.actions.state")
				local line = action_state.get_current_line()
				Util.telescope("find_files", { hidden = true, default_text = line })()
			end

			return {
				defaults = {
					prompt_prefix = " ",
					selection_caret = " ",
					-- open files in the first window that is an actual file.
					-- use the current window if no other window is available.
					get_selection_window = function()
						local wins = vim.api.nvim_list_wins()
						table.insert(wins, 1, vim.api.nvim_get_current_win())
						for _, win in ipairs(wins) do
							local buf = vim.api.nvim_win_get_buf(win)
							if vim.bo[buf].buftype == "" then
								return win
							end
						end
						return 0
					end,
					mappings = {
						i = {
							["<c-t>"] = open_with_trouble,
							["<a-t>"] = open_selected_with_trouble,
							["<a-i>"] = find_files_no_ignore,
							["<a-h>"] = find_files_with_hidden,
							["<C-n>"] = actions.cycle_history_next,
							["<C-p>"] = actions.cycle_history_prev,
							["<C-j>"] = actions.move_selection_next,
							["<C-k>"] = actions.move_selection_previous,
							["<C-f>"] = actions.preview_scrolling_down,
							["<C-b>"] = actions.preview_scrolling_up,
						},
						n = {
							["q"] = actions.close,
						},
					},
				},
			}
		end,
	},

	-- Hop is an EasyMotion-like plugin allowing you to jump anywhere in a document with as few keystrokes as possible.
	{
		"phaazon/hop.nvim",
		dependencies = {
			"ziontee113/syntax-tree-surfer",
			"mfussenegger/nvim-treehopper",
		},
		config = function()
			require("hop").setup({ keys = "etovxqpdygfblzhckisuran" })
		end,
	},

	-- buffer remove
	"famiu/bufdelete.nvim",
	{
		"echasnovski/mini.bufremove",
		event = "VeryLazy",
		keys = {
			{
				"bd",
				function()
					local bd = require("mini.bufremove").delete
					if vim.bo.modified then
						local choice =
							vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname()), "&Yes\n&No\n&Cancel")
						if choice == 1 then -- Yes
							vim.cmd.write()
							bd(0)
						elseif choice == 2 then -- No
							bd(0, true)
						end
					else
						bd(0)
					end
				end,
				desc = "Delete Buffer",
			},
      -- stylua: ignore
      { "<leader>bD", function() require("mini.bufremove").delete(0, true) end, desc = "Delete Buffer (Force)" },
		},
	},

	-- better diagnostics list and others
	{
		"folke/trouble.nvim",
		event = "VeryLazy",
		cmd = { "TroubleToggle", "Trouble" },
		opts = { use_diagnostic_signs = true },
		keys = {
			{ "<leader>xx", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document Diagnostics (Trouble)" },
			{ "<leader>xX", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics (Trouble)" },
			{ "<leader>xL", "<cmd>TroubleToggle loclist<cr>", desc = "Location List (Trouble)" },
			{ "<leader>xQ", "<cmd>TroubleToggle quickfix<cr>", desc = "Quickfix List (Trouble)" },
			{
				"[q",
				function()
					if require("trouble").is_open() then
						require("trouble").previous({ skip_groups = true, jump = true })
					else
						local ok, err = pcall(vim.cmd.cprev)
						if not ok then
							vim.notify(err, vim.log.levels.ERROR)
						end
					end
				end,
				desc = "Previous trouble/quickfix item",
			},
			{
				"]q",
				function()
					if require("trouble").is_open() then
						require("trouble").next({ skip_groups = true, jump = true })
					else
						local ok, err = pcall(vim.cmd.cnext)
						if not ok then
							vim.notify(err, vim.log.levels.ERROR)
						end
					end
				end,
				desc = "Next trouble/quickfix item",
			},
		},
	},

	-- Finds and lists all of the TODO, HACK, BUG, etc comment
	-- in your project and loads them into a browsable list.
	{
		"folke/todo-comments.nvim",
		cmd = { "TodoTrouble", "TodoTelescope" },
		event = "VeryLazy",
		config = true,
    -- stylua: ignore
    keys = {
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
      { "<leader>xt", "<cmd>TodoTrouble<cr>", desc = "Todo (Trouble)" },
      { "<leader>xT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme (Trouble)" },
      { "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Todo" },
      { "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme" },
    },
	},

	-- search/replace in multiple files
	{
		"nvim-pack/nvim-spectre",
		event = "VeryLazy",
		build = false,
		cmd = "Spectre",
		opts = { open_cmd = "noswapfile vnew" },
    -- stylua: ignore
    keys = {
      { "<leader>sr", function() require("spectre").open() end, desc = "Replace in files (Spectre)" },
    },
	},

	-- file explorer
	{
		"stevearc/oil.nvim",
		event = "VeryLazy",
		opts = {},
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("oil").setup({
				keymaps = {
					["g?"] = "actions.show_help",
					["<CR>"] = "actions.select",
					["<C-s>"] = "actions.select_vsplit",
					["<C-h>"] = "actions.select_split",
					["<C-t>"] = "actions.select_tab",
					["<C-p>"] = "actions.preview",
					["<C-c>"] = "actions.close",
					["<C-l>"] = "actions.refresh",
					["-"] = "actions.parent",
					["_"] = "actions.open_cwd",
					["`"] = "actions.cd",
					["~"] = "actions.tcd",
					["gs"] = "actions.change_sort",
					["gx"] = "actions.open_external",
					["g."] = "actions.toggle_hidden",
					["g\\"] = "actions.toggle_trash",
					["q"] = "actions.close",
				},
			})
		end,
	},
	{
		"nvim-neo-tree/neo-tree.nvim",
		event = "VeryLazy",
		branch = "v3.x",
		cmd = "Neotree",
		dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons" },
		keys = {
			{
				"<leader>fe",
				function()
					require("neo-tree.command").execute({ toggle = true, dir = Util.root() })
				end,
				desc = "Explorer NeoTree (root dir)",
			},
			{
				"<C-n>",
				function()
					require("neo-tree.command").execute({ toggle = true, dir = vim.loop.cwd() })
				end,
				desc = "Explorer NeoTree (cwd)",
			},
			{
				"<leader>ge",
				function()
					require("neo-tree.command").execute({ source = "git_status", toggle = true })
				end,
				desc = "Git explorer",
			},
			{
				"<leader>be",
				function()
					require("neo-tree.command").execute({ source = "buffers", toggle = true })
				end,
				desc = "Buffer explorer",
			},
		},
		deactivate = function()
			vim.cmd([[Neotree close]])
		end,
		init = function()
			if vim.fn.argc(-1) == 1 then
				local stat = vim.loop.fs_stat(vim.fn.argv(0))
				if stat and stat.type == "directory" then
					require("neo-tree")
				end
			end
		end,
		opts = {
			sources = { "filesystem", "buffers", "git_status", "document_symbols" },
			open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "Outline" },
			filesystem = {
				bind_to_cwd = false,
				follow_current_file = { enabled = true },
				use_libuv_file_watcher = true,
			},
			window = {
				mappings = {
					["<space>"] = "none",
				},
			},
			default_component_configs = {
				indent = {
					with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
					expander_collapsed = "",
					expander_expanded = "",
					expander_highlight = "NeoTreeExpander",
				},
			},
		},
		config = function(_, opts)
			local function on_move(data)
				Util.lsp.on_rename(data.source, data.destination)
			end

			local events = require("neo-tree.events")
			opts.event_handlers = opts.event_handlers or {}
			vim.list_extend(opts.event_handlers, {
				{ event = events.FILE_MOVED, handler = on_move },
				{ event = events.FILE_RENAMED, handler = on_move },
			})
			require("neo-tree").setup(opts)
			vim.api.nvim_create_autocmd("TermClose", {
				pattern = "*lazygit",
				callback = function()
					if package.loaded["neo-tree.sources.git_status"] then
						require("neo-tree.sources.git_status").refresh()
					end
				end,
			})
		end,
	},

	-- minimap
	{
		"echasnovski/mini.map",
		branch = "stable",
		event = "BufWinEnter",
		dependencies = { "dstein64/nvim-scrollview", enabled = false },
		config = function()
			local map = require("mini.map")
			map.setup({
				integrations = {
					map.gen_integration.builtin_search(),
					map.gen_integration.diagnostic({
						error = "DiagnosticFloatingError",
						warn = "DiagnosticFloatingWarn",
						info = "DiagnosticFloatingInfo",
						hint = "DiagnosticFloatingHint",
					}),
				},
				symbols = {
					encode = map.gen_encode_symbols.dot("4x2"),
					scroll_line = "",
				},
				window = {
					side = "right",
					width = 16, -- set to 1 for a pure scrollbar :)
					winblend = 15,
					show_integration_count = false,
					focusable = true,
				},
			})
		end,
		keys = {
			{ "<leader>mo", "<cmd>lua require('mini.map').open()<cr>", desc = "Minimap Open" },
			{ "<leader>mc", "<cmd>lua require('mini.map').close()<cr>", desc = "Minimap Close" },
			{ "<leader>mf", "<cmd>lua require('mini.map').toggle_focus()<cr>", desc = "Minimap Focus" },
		},
	},

	-- focus and maybe protect your left-rotated neck
	{
		"nyngwang/NeoZoom.lua",
		config = function()
			require("neo-zoom").setup({})
		end,
	},

	-- Nvim + Pomodoro!
	{
		"dbinagi/nomodoro",
		config = function()
			require("nomodoro").setup({
				work_time = 25,
				break_time = 5,
				menu_available = true,
				texts = {
					on_break_complete = "TIME IS UP!",
					on_work_complete = "TIME IS UP!",
					status_icon = " ",
					timer_format = "!%0M:%0S", -- To include hours: '!%0H:%0M:%0S'
				},
				on_work_complete = function() end,
				on_break_complete = function() end,
			})
		end,
	},

	-- type text in a file, send it to a live REPL,
	{
		"jpalardy/vim-slime",
		config = function()
			vim.g.slime_target = "tmux"
			vim.g.slime_default_config = {
				socket_name = "default",
				target_pane = "{last}",
			}
		end,
	},

	-- Smooth scrolling for window movement commands
	{
		"karb94/neoscroll.nvim",
		config = function()
			require("neoscroll").setup({
				easing_function = "quadratic", -- Default easing function
				-- Set any other options as needed
			})

			local t = {}
			-- Syntax: t[keys] = {function, {function arguments}}
			-- Use the "sine" easing function
			t["<C-u>"] = { "scroll", { "-vim.wo.scroll", "true", "350", [['sine']] } }
			t["<C-d>"] = { "scroll", { "vim.wo.scroll", "true", "350", [['sine']] } }
			-- Use the "circular" easing function
			t["<C-b>"] = { "scroll", { "-vim.api.nvim_win_get_height(0)", "true", "500", [['circular']] } }
			t["<C-f>"] = { "scroll", { "vim.api.nvim_win_get_height(0)", "true", "500", [['circular']] } }
			-- Pass "nil" to disable the easing animation (constant scrolling speed)
			t["<C-y>"] = { "scroll", { "-0.10", "false", "100", nil } }
			t["<C-e>"] = { "scroll", { "0.10", "false", "100", nil } }
			-- When no easing function is provided the default easing function (in this case "quadratic") will be used
			t["zt"] = { "zt", { "300" } }
			t["zz"] = { "zz", { "300" } }
			t["zb"] = { "zb", { "300" } }

			require("neoscroll.config").set_mappings(t)
		end,
	},

	-- A simple and opinionated NeoVim plugin for switching between windows in the current tab page.
	{
		"https://gitlab.com/yorickpeterse/nvim-window.git",
		config = function()
			require("nvim-window").setup({
				normal_hl = "BlackOnLightYellow",
				hint_hl = "Bold",
				border = "none",
			})
		end,
	},

	-- Animated expand width of the current window;
	{
		"anuvyklack/windows.nvim",
		dependencies = {
			"anuvyklack/middleclass",
			"anuvyklack/animation.nvim",
		},
		config = function()
			require("windows").setup({
				autowidth = { --		       |windows.autowidth|
					enable = false,
					winwidth = 5, --		        |windows.winwidth|
					filetype = { --	      |windows.autowidth.filetype|
						help = 2,
					},
				},
				ignore = { --			  |windows.ignore|
					buftype = { "quickfix" },
					filetype = {
						"diffviewfilepanel",
						"NvimTree",
						"DiffviewFilePanel",
						"neo-tree",
						"undotree",
						"gundo",
					},
				},
			})
		end,
	},

	-- Vim-doge is a (Do)cumentation (Ge)nerator which will generate a proper documentation skeleton based on certain expressions (mainly functions).
	{
		"kkoomen/vim-doge",
		build = function()
			vim.cmd([[call doge#install()]])
		end,
		dependencies = {
			{
				"danymat/neogen",
				config = function()
					require("neogen").setup({
						snippet_engine = "luasnip",
						enabled = true,
						languages = {
							lua = {
								template = {
									annotation_convention = "ldoc",
								},
							},
							python = {
								template = {
									annotation_convention = "google_docstrings",
								},
							},
							rust = {
								template = {
									annotation_convention = "rustdoc",
								},
							},
							javascript = {
								template = {
									annotation_convention = "jsdoc",
								},
							},
							typescript = {
								template = {
									annotation_convention = "tsdoc",
								},
							},
							typescriptreact = {
								template = {
									annotation_convention = "tsdoc",
								},
							},
						},
					})
				end,
			},
		},
		config = function()
			vim.g.doge_enable_mappings = 1
			vim.g.doge_doc_standard_python = "numpy"
			vim.g.doge_mapping_comment_jump_forward = "<C-j>"
			vim.g.doge_mapping_comment_jump_backward = "<C-k>"
			vim.g.doge_buffer_mappings = 1
			vim.g.doge_comment_jump_modes = { "n", "i", "s" }
			vim.g.doge_mapping = ""
		end,
	},

	-- A code outline window for skimming and quick navigation
	{
		desc = "Aerial Symbol Browser",
		{
			"stevearc/aerial.nvim",
			event = "VeryLazy",
			opts = function()
				local icons = vim.deepcopy(Config.defaults.icons.kinds)

				-- HACK: fix lua's weird choice for `Package` for control
				-- structures like if/else/for/etc.
				icons.lua = { Package = icons.Control }

				---@type table<string, string[]>|false
				local filter_kind = false
				if Config.kind_filter then
					filter_kind = assert(vim.deepcopy(Config.kind_filter))
					filter_kind._ = filter_kind.default
					filter_kind.default = nil
				end

				local opts = {
					attach_mode = "global",
					backends = { "lsp", "treesitter", "markdown", "man" },
					show_guides = true,
					layout = {
						resize_to_content = false,
						win_opts = {
							winhl = "Normal:NormalFloat,FloatBorder:NormalFloat,SignColumn:SignColumnSB",
							signcolumn = "yes",
							statuscolumn = " ",
						},
					},
					icons = icons,
					filter_kind = filter_kind,
	       -- stylua: ignore
	       guides = {
	         mid_item   = "├╴",
	         last_item  = "└╴",
	         nested_top = "│ ",
	         whitespace = "  ",
	       },
				}
				return opts
			end,
			keys = {
				{ "<leader>cs", "<cmd>AerialToggle<cr>", desc = "Aerial (Symbols)" },
			},
		},

		-- Telescope integration
		{
			"nvim-telescope/telescope.nvim",
			optional = true,
			opts = function()
				Util.on_load("telescope.nvim", function()
					require("telescope").load_extension("aerial")
				end)
			end,
			keys = {
				{
					"<leader>ss",
					"<cmd>Telescope aerial<cr>",
					desc = "Goto Symbol (Aerial)",
				},
			},
		},

		-- edgy integration
		{
			"folke/edgy.nvim",
			optional = true,
			opts = function(_, opts)
				local edgy_idx = Util.plugin.extra_idx("ui.edgy")
				local aerial_idx = Util.plugin.extra_idx("editor.aerial")

				if edgy_idx and edgy_idx > aerial_idx then
					Util.warn(
						"The `edgy.nvim` extra must be **imported** before the `aerial.nvim` extra to work properly.",
						{
							title = "LazyVim",
						}
					)
				end

				opts.right = opts.right or {}
				table.insert(opts.right, {
					title = "Aerial",
					ft = "aerial",
					pinned = true,
					open = "AerialOpen",
				})
			end,
		},
	},

	-- Navigate file system using column view
	{
		"echasnovski/mini.files",
		event = "VeryLazy",
		opts = {
			windows = {
				preview = true,
				width_focus = 30,
				width_preview = 30,
			},
			options = {
				-- Whether to use for editing directories
				-- Disabled by default in LazyVim because neo-tree is used for that
				use_as_default_explorer = false,
			},
		},
		keys = {
			{
				"<leader>fm",
				function()
					require("mini.files").open(vim.api.nvim_buf_get_name(0), true)
				end,
				desc = "Open mini.files (directory of current file)",
			},
			{
				"<leader>fM",
				function()
					require("mini.files").open(vim.loop.cwd(), true)
				end,
				desc = "Open mini.files (cwd)",
			},
		},
		config = function(_, opts)
			require("mini.files").setup(opts)

			local show_dotfiles = true
			local filter_show = function(fs_entry)
				return true
			end
			local filter_hide = function(fs_entry)
				return not vim.startswith(fs_entry.name, ".")
			end

			local toggle_dotfiles = function()
				show_dotfiles = not show_dotfiles
				local new_filter = show_dotfiles and filter_show or filter_hide
				require("mini.files").refresh({ content = { filter = new_filter } })
			end

			vim.api.nvim_create_autocmd("User", {
				pattern = "MiniFilesBufferCreate",
				callback = function(args)
					local buf_id = args.data.buf_id
					-- Tweak left-hand side of mapping to your liking
					vim.keymap.set("n", "g.", toggle_dotfiles, { buffer = buf_id })
				end,
			})

			vim.api.nvim_create_autocmd("User", {
				pattern = "MiniFilesActionRename",
				callback = function(event)
					require("core.util").lsp.on_rename(event.data.from, event.data.to)
				end,
			})
		end,
	},

	-- A small Neovim plugin for previewing native LSP's goto definition, type definition, implementation, declaration and references calls in floating windows.
	{
		"rmagatti/goto-preview",
		config = function()
			require("goto-preview").setup({})
		end,
	},

	-- measure startuptime
	{
		"dstein64/vim-startuptime",
		cmd = "StartupTime",
		config = function()
			vim.g.startuptime_tries = 10
		end,
	},

	-- Session management. This saves your session in the background,
	-- keeping track of open buffers, window arrangement, and more.
	-- You can restore sessions when returning through the dashboard.
	{
		"folke/persistence.nvim",
		event = "BufReadPre",
		opts = { options = vim.opt.sessionoptions:get() },
    -- stylua: ignore
    keys = {
      { "<leader>qs", function() require("persistence").load() end, desc = "Restore Session" },
      { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
      { "<leader>qd", function() require("persistence").stop() end, desc = "Don't Save Current Session" },
    },
	},

	-- library used by other plugins
	{ "nvim-lua/plenary.nvim", lazy = true },

	--Keyboard-centric popup navigation
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{
				"SmiteshP/nvim-navbuddy",
				dependencies = {
					"SmiteshP/nvim-navic",
					"MunifTanjim/nui.nvim",
				},
				opts = { lsp = { auto_attach = true } },
			},
		},
		config = function()
			local navbuddy = require("nvim-navbuddy")
			local actions = require("nvim-navbuddy.actions")

			navbuddy.setup({
				window = {
					border = "single", -- "rounded", "double", "solid", "none"
					-- or an array with eight chars building up the border in a clockwise fashion
					-- starting with the top-left corner. eg: { "╔", "═" ,"╗", "║", "╝", "═", "╚", "║" }.
					size = "60%", -- Or table format example: { height = "40%", width = "100%"}
					position = "50%", -- Or table format example: { row = "100%", col = "0%"}
					scrolloff = nil, -- scrolloff value within navbuddy window
					sections = {
						left = {
							size = "20%",
							border = nil, -- You can set border style for each section individually as well.
						},
						mid = {
							size = "40%",
							border = nil,
						},
						right = {
							-- No size option for right most section. It fills to
							-- remaining area.
							border = nil,
							preview = "leaf", -- Right section can show previews too.
							-- Options: "leaf", "always" or "never"
						},
					},
				},
				node_markers = {
					enabled = true,
					icons = {
						leaf = "  ",
						leaf_selected = " → ",
						branch = " ",
					},
				},
				icons = require("core.config.util").defaults.icons.kinds,
				use_default_mappings = true, -- If set to false, only mappings set
				mappings = {
					["<esc>"] = actions.close(), -- Close and cursor to original location
					["q"] = actions.close(),

					["j"] = actions.next_sibling(), -- down
					["k"] = actions.previous_sibling(), -- up

					["h"] = actions.parent(), -- Move to left panel
					["l"] = actions.children(), -- Move to right panel
					["0"] = actions.root(), -- Move to first panel

					["v"] = actions.visual_name(), -- Visual selection of name
					["V"] = actions.visual_scope(), -- Visual selection of scope

					["y"] = actions.yank_name(), -- Yank the name to system clipboard "+
					["Y"] = actions.yank_scope(), -- Yank the scope to system clipboard "+

					["i"] = actions.insert_name(), -- Insert at start of name
					["I"] = actions.insert_scope(), -- Insert at start of scope

					["a"] = actions.append_name(), -- Insert at end of name
					["A"] = actions.append_scope(), -- Insert at end of scope

					["r"] = actions.rename(), -- Rename currently focused symbol

					["d"] = actions.delete(), -- Delete scope

					["f"] = actions.fold_create(), -- Create fold of current scope
					["F"] = actions.fold_delete(), -- Delete fold of current scope

					["c"] = actions.comment(), -- Comment out current scope

					["<enter>"] = actions.select(), -- Goto selected symbol
					["o"] = actions.select(),

					["J"] = actions.move_down(), -- Move focused node down
					["K"] = actions.move_up(), -- Move focused node up

					["s"] = actions.toggle_preview(), -- Show preview of current node

					["<C-v>"] = actions.vsplit(), -- Open selected node in a vertical split
					["<C-s>"] = actions.hsplit(), -- Open selected node in a horizontal split

					["t"] = actions.telescope({ -- Fuzzy finder at current level.
						layout_config = { -- All options that can be
							height = 0.60, -- passed to telescope.nvim's
							width = 0.60, -- default can be passed here.
							prompt_position = "top",
							preview_width = 0.50,
						},
						layout_strategy = "horizontal",
					}),

					["g?"] = actions.help(), -- Open mappings help window
				},
				lsp = {
					auto_attach = false, -- If set to true, you don't need to manually use attach function
					preference = nil, -- list of lsp server names in order of preference
				},
				source_buffer = {
					follow_node = true, -- Keep the current node in focus on the source buffer
					highlight = true, -- Highlight the currently focused node
					reorient = "smart", -- "smart", "top", "mid" or "none"
					scrolloff = nil, -- scrolloff value when navbuddy is open
				},
			})
		end,

		keys = {
			{
				"<leader>nd",
				function()
					require("nvim-navbuddy").open()
				end,
				desc = "NavBuddy",
			},
		},
	},

	{
		"kristijanhusak/vim-dadbod-ui",
		dependencies = {
			{ "tpope/vim-dadbod", lazy = true },
			{ "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
		},
		cmd = {
			"DBUI",
			"DBUIToggle",
			"DBUIAddConnection",
			"DBUIFindBuffer",
		},
		init = function()
			vim.g.db_ui_use_nerd_fonts = 1
		end,
	},
	{
		"jackMort/ChatGPT.nvim",
		event = "VeryLazy",
		config = function()
			local home = vim.fn.expand("$HOME")
			require("chatgpt").setup({
				api_key_cmd = "cat " .. home .. "/.chat",
				yank_register = "+",
				edit_with_instructions = {
					diff = false,
					keymaps = {
						close = "<C-c>",
						accept = "<C-y>",
						toggle_diff = "<C-d>",
						toggle_settings = "<C-o>",
						toggle_help = "<C-h>",
						cycle_windows = "<Tab>",
						use_output_as_input = "<C-i>",
					},
				},
				chat = {
					welcome_message = WELCOME_MESSAGE,
					loading_text = "Loading, please wait ...",
					question_sign = "",
					answer_sign = "󰚩",
					border_left_sign = "",
					border_right_sign = "",
					max_line_length = 120,
					sessions_window = {
						active_sign = " 󰄵 ",
						inactive_sign = " 󰄱 ",
						current_line_sign = "",
						border = {
							style = "rounded",
							text = {
								top = " Sessions ",
							},
						},
						win_options = {
							winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
						},
					},
					keymaps = {
						close = "<C-c>",
						yank_last = "<C-y>",
						yank_last_code = "<C-k>",
						scroll_up = "<C-u>",
						scroll_down = "<C-d>",
						new_session = "<C-n>",
						cycle_windows = "<Tab>",
						cycle_modes = "<C-f>",
						next_message = "<C-j>",
						prev_message = "<C-k>",
						select_session = "<Space>",
						rename_session = "r",
						delete_session = "d",
						draft_message = "<C-r>",
						edit_message = "e",
						delete_message = "d",
						toggle_settings = "<C-o>",
						toggle_sessions = "<C-p>",
						toggle_help = "<C-h>",
						toggle_message_role = "<C-r>",
						toggle_system_role_open = "<C-s>",
						stop_generating = "<C-x>",
					},
				},
				popup_layout = {
					default = "center",
					center = {
						width = "80%",
						height = "80%",
					},
					right = {
						width = "30%",
						width_settings_open = "50%",
					},
				},
				popup_window = {
					border = {
						highlight = "FloatBorder",
						style = "rounded",
						text = {
							top = " ChatGPT ",
						},
					},
					win_options = {
						wrap = true,
						linebreak = true,
						foldcolumn = "1",
						winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
					},
					buf_options = {
						filetype = "markdown",
					},
				},
				system_window = {
					border = {
						highlight = "FloatBorder",
						style = "rounded",
						text = {
							top = " SYSTEM ",
						},
					},
					win_options = {
						wrap = true,
						linebreak = true,
						foldcolumn = "2",
						winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
					},
				},
				popup_input = {
					prompt = "  ",
					border = {
						highlight = "FloatBorder",
						style = "rounded",
						text = {
							top_align = "center",
							top = " Prompt ",
						},
					},
					win_options = {
						winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
					},
					submit = "<C-Enter>",
					submit_n = "<Enter>",
					max_visible_lines = 20,
				},
				settings_window = {
					setting_sign = "  ",
					border = {
						style = "rounded",
						text = {
							top = " Settings ",
						},
					},
					win_options = {
						winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
					},
				},
				help_window = {
					setting_sign = "  ",
					border = {
						style = "rounded",
						text = {
							top = " Help ",
						},
					},
					win_options = {
						winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
					},
				},
				openai_params = {
					model = "gpt-3.5-turbo",
					frequency_penalty = 0,
					presence_penalty = 0,
					max_tokens = 300,
					temperature = 0,
					top_p = 1,
					n = 1,
				},
				openai_edit_params = {
					model = "gpt-3.5-turbo",
					frequency_penalty = 0,
					presence_penalty = 0,
					temperature = 0,
					top_p = 1,
					n = 1,
				},
				use_openai_functions_for_edits = false,
				actions_paths = {},
				show_quickfixes_cmd = "Trouble quickfix",
				predefined_chat_gpt_prompts = "https://raw.githubusercontent.com/f/awesome-chatgpt-prompts/main/prompts.csv",
				highlights = {
					help_key = "@symbol",
					help_description = "@comment",
				},
			})
			require("which-key").register({
				mode = { "n", "v" },
				C = {
					name = "ChatGPT",
					c = { "<cmd>ChatGPT<CR>", "ChatGPT" },
					e = { "<cmd>ChatGPTEditWithInstruction<CR>", "Edit with instruction", mode = { "n", "v" } },
					g = { "<cmd>ChatGPTRun grammar_correction<CR>", "Grammar Correction", mode = { "n", "v" } },
					t = { "<cmd>ChatGPTRun translate<CR>", "Translate", mode = { "n", "v" } },
					k = { "<cmd>ChatGPTRun keywords<CR>", "Keywords", mode = { "n", "v" } },
					d = { "<cmd>ChatGPTRun docstring<CR>", "Docstring", mode = { "n", "v" } },
					a = { "<cmd>ChatGPTRun add_tests<CR>", "Add Tests", mode = { "n", "v" } },
					o = { "<cmd>ChatGPTRun optimize_code<CR>", "Optimize Code", mode = { "n", "v" } },
					s = { "<cmd>ChatGPTRun summarize<CR>", "Summarize", mode = { "n", "v" } },
					f = { "<cmd>ChatGPTRun fix_bugs<CR>", "Fix Bugs", mode = { "n", "v" } },
					x = { "<cmd>ChatGPTRun explain_code<CR>", "Explain Code", mode = { "n", "v" } },
					r = { "<cmd>ChatGPTRun roxygen_edit<CR>", "Roxygen Edit", mode = { "n", "v" } },
					l = {
						"<cmd>ChatGPTRun code_readability_analysis<CR>",
						"Code Readability Analysis",
						mode = { "n", "v" },
					},
				},
			})
		end,
		dependencies = {
			"MunifTanjim/nui.nvim",
			"nvim-lua/plenary.nvim",
			"folke/trouble.nvim",
			"nvim-telescope/telescope.nvim",
		},
	},

  -- listchars
  { "fraso-dev/nvim-listchars", config = true }
}
