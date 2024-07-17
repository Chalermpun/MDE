return {
  {
    "echasnovski/mini.operators",
    version = false,
    config = function()
      require("mini.operators").setup({
        evaluate = {
          prefix = "g=",
          func = nil,
        },
        exchange = {
          prefix = "gx",
          reindent_linewise = true,
        },
        multiply = {
          prefix = "gm",
          func = nil,
        },
        replace = {
          prefix = "gp",
          reindent_linewise = true,
        },
        sort = {
          prefix = "gs",
          func = nil,
        },
      })
    end,
  },
}
