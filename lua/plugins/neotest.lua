return {
  {
    "nvim-neotest/neotest",
    event = "VeryLazy",
    dependencies = {
      "jfpedroza/neotest-elixir",
      "nvim-neotest/neotest-python",
      "nvim-neotest/nvim-nio",
    },
    keys = {
      {
        "<leader>ta",
        function()
          require("neotest").run.attach()
        end,
        desc = "Neotest Attach",
      },
      {
        "<leader>tf",
        function()
          require("neotest").run.run(vim.fn.expand("%"))
        end,
        desc = "Neotest Run File",
      },
      {
        "<leader>tF",
        function()
          require("neotest").run.run({ vim.fn.expand("%"), strategy = "dap" })
        end,
        desc = "Neotest Debug File",
      },
      {
        "<leader>tl",
        function()
          require("neotest").run.run_last()
        end,
        desc = "Neotest Run Last",
      },
      {
        "<leader>tL",
        function()
          require("neotest").run.run_last({ strategy = "dap" })
        end,
        desc = "Neotest Debug Last",
      },
      {
        "<leader>tn",
        function()
          require("neotest").run.run()
        end,
        desc = "Neotest Run Nearest",
      },
      {
        "<leader>tN",
        function()
          require("neotest").run.run({ strategy = "dap" })
        end,
        desc = "Neotest Debug Nearest",
      },
      {
        "<leader>to",
        function()
          require("neotest").output.open({ enter = true })
        end,
        desc = "Neotest Output",
      },
      {
        "<leader>tS",
        function()
          require("neotest").run.stop()
        end,
        desc = "Neotest Stop",
      },
      {
        "<leader>ts",
        function()
          require("neotest").summary.toggle()
        end,
        desc = "Neotest Summary",
      },
      {
        "<leader>td",
        function()
          require("neotest").run.run(vim.fn.expand("%:p:h"))
        end,
        desc = "Neotest Run Dir",
      },
    },
    config = function()
      require("neotest").setup({
        adapters = { require("neotest-python")({ runner = "pytest", args = { "-rA" } }) },
      })
    end,
  },
}
