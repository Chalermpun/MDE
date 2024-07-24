return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    keys = {
      {
        "<C-n>",
        function()
          require("neo-tree.command").execute({ toggle = true, dir = vim.loop.cwd() })
        end,
        desc = "Explorer NeoTree (cwd)",
      },
    },
    config = function()
      local signs = require("config.util").defaults.icons.diagnostics
      require("neo-tree").setup({
        enable_diagnostics = true,
        default_component_configs = {
          diagnostics = {
            symbols = {
              hint = signs.Hint,
              info = signs.Info,
              warn = signs.Warn,
              error = signs.Error,
            },
            highlights = {
              hint = "DiagnosticSignHint",
              info = "DiagnosticSignInfo",
              warn = "DiagnosticSignWarn",
              error = "DiagnosticSignError",
            },
          },
        }
      })
    end,
  },
}
