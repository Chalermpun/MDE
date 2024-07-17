return {
  {
    "nyngwang/NeoZoom.lua",
    config = function()
      require("neo-zoom").setup({})
      vim.keymap.set("n", "<leader>zz", "<cmd>NeoZoomToggle<cr>", { desc = "NeoZoomToggle" })
    end,
  },
}
