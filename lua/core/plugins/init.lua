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

local formatting = require("core.plugins.formatting")
local editor = require("core.plugins.editor")
local coding = require("core.plugins.coding")
local ui = require("core.plugins.ui")
local colourscheme = require("core.plugins.colorscheme")
local lang = require("core.plugins.lang")
local treesitter = require("core.plugins.treesitter")
local lsp = require("core.plugins.lsp")
local linting = require("core.plugins.linting")
local dap_core = require("core.plugins.dap.core")
local dap_nlua = require("core.plugins.dap.nlua")
local mini_hipatterns = require("core.plugins.mini-hipatterns")
local utils = require("core.plugins.utils")

local plugins = {
	formatting,
	ui,
	editor,
	coding,
	lang,
	treesitter,
	lsp,
	colourscheme,
	linting,
	dap_core,
	dap_nlua,
	utils,
	mini_hipatterns,
}
local opts = {}
require("lazy").setup(plugins, opts)
