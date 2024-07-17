return {
  {
    "fraso-dev/nvim-listchars",
    config = function()
      require("nvim-listchars").setup()
      vim.keymap.set("n", "<leader>Lt", "<cmd>ListcharsToggle<cr>", { desc = "Listchars Toggle" })
    end,
  },
}
