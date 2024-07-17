-- Color Picker
-- l / d / , (1 / 5 / 10) Increase the value times delta of the slider.
-- h / s / m (1 / 5 / 10) Decrease the value times delta of the slider.
-- mapping: H / M / L (0 / 50 / 100), 1 - 9 (10% - 90%)
-- mapping: a Toggle show/hide alpha (transparency) slider.
-- mapping: r Reset input and output to default, and hide alpha slider and previous colors palette.
-- mapping: o Toggle output mode. See |ccc-option-outputs|.
-- mapping: i Toggle input mode. See |ccc-option-inputs|.
return {
  {
    "uga-rosa/ccc.nvim",
    event = "VeryLazy",
    opts = {},
    cmd = { "CccPick", "CccConvert", "CccHighlighterEnable", "CccHighlighterDisable", "CccHighlighterToggle" },
    config = function(_, opts)
      require("ccc").setup(opts)
      vim.keymap.set("n", "<leader>zp", "<cmd>CccPick<cr>", { desc = "Color Picker" })
      vim.keymap.set("n", "<leader>zc", "<cmd>CccConvert<cr>", { desc = "Color Convert" })
      vim.keymap.set("n", "<leader>zh", "<cmd>CccHighlighterToggle<cr>", { desc = "Color Toggle Highlighter" })
    end,
  },
}
