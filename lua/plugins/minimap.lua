return {
  {
    "echasnovski/mini.map",
    branch = "stable",
    event = "VeryLazy",
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
          width = 16,
          winblend = 15,
          show_integration_count = false,
          focusable = true,
        },
      })
    end,
    keys = {
      { "<leader>mo", "<cmd>lua require('mini.map').open()<cr>",         desc = "Minimap Open" },
      { "<leader>mc", "<cmd>lua require('mini.map').close()<cr>",        desc = "Minimap Close" },
      { "<leader>mf", "<cmd>lua require('mini.map').toggle_focus()<cr>", desc = "Minimap Focus" },
    },
  },
}
