return {
  "linux-cultist/venv-selector.nvim",
  version = false,
  dependencies = { "neovim/nvim-lspconfig", "nvim-telescope/telescope.nvim", "mfussenegger/nvim-dap-python" },
  config = function()
    require("venv-selector").setup({ stay_on_this_version = true })
  end,
  event = "VeryLazy",
  keys = {
    { "<leader>cv", "<cmd>VenvSelect<cr>", desc = "Select VirtualEnv" },
  },
}
