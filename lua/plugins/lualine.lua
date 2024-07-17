local function fg(name)
  local hl = vim.api.nvim_get_hl and vim.api.nvim_get_hl(0, { name = name })
      or vim.api.nvim_get_hl_by_name(name, true)
  local fg = hl and (hl.fg or hl.foreground)
  return fg and { fg = string.format("#%06x", fg) } or nil
end

local function format(component, text, hl_group)
  if not hl_group then
    return text
  end
  component.hl_cache = component.hl_cache or {}
  local lualine_hl_group = component.hl_cache[hl_group]
  if not lualine_hl_group then
    local utils = require("lualine.utils.utils")
    lualine_hl_group =
        component:create_hl({ fg = utils.extract_highlight_colors(hl_group, "fg") }, "LV_" .. hl_group)
    component.hl_cache[hl_group] = lualine_hl_group
  end
  return component:format_hl(lualine_hl_group) .. text .. component:get_default_hl()
end

local function pretty_path(opts)
  opts = vim.tbl_extend("force", {
    relative = "cwd",
    modified_hl = "Constant",
  }, opts or {})

  return function(self)
    local path = vim.fn.expand("%:p")

    if path == "" then
      return ""
    end
    local cwd = vim.fn.getcwd()
    local root = vim.fn.fnamemodify(vim.fn.finddir(".git", cwd .. ";"), ":h")

    if root == "" then
      root = cwd
    end

    if opts.relative == "cwd" and path:find(cwd, 1, true) == 1 then
      path = path:sub(#cwd + 2)
    else
      path = path:sub(#root + 2)
    end

    local sep = package.config:sub(1, 1)
    local parts = vim.split(path, "[\\/]")
    if #parts > 3 then
      parts = { parts[1], "…", parts[#parts - 1], parts[#parts] }
    end

    if opts.modified_hl and vim.bo.modified then
      parts[#parts] = format(self, parts[#parts], opts.modified_hl)
    end

    return table.concat(parts, sep)
  end
end

local function root_dir(opts)
  opts = vim.tbl_extend("force", {
    cwd = false,
    subdirectory = true,
    parent = true,
    other = true,
    icon = "󱉭 ",
    color = fg("Special"),
  }, opts or {})

  local function get()
    local cwd = vim.fn.getcwd()
    local root = vim.fn.fnamemodify(vim.fn.finddir(".git", cwd .. ";"), ":h")

    if root == "" then
      root = cwd
    end
    local name = vim.fs.basename(root)

    if root == cwd then
      return opts.cwd and name
    elseif root:find(cwd, 1, true) == 1 then
      return opts.subdirectory and name
    elseif cwd:find(root, 1, true) == 1 then
      return opts.parent and name
    else
      return opts.other and name
    end
  end

  return {
    function()
      return (opts.icon and opts.icon .. " ") .. (get() or "")
    end,
    cond = function()
      return type(get()) == "string"
    end,
    color = opts.color,
  }
end

return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
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
            timer_format = "!%0M:%0S",
          },
          on_work_complete = function() end,
          on_break_complete = function() end,
        })
        vim.keymap.set("n", "<leader>nw", "<cmd>NomoWork<cr>", { desc = "NomoWork" })
        vim.keymap.set("n", "<leader>nb", "<cmd>NomoBreak<cr>", { desc = "NomoBreak" })
        vim.keymap.set("n", "<leader>ns", "<cmd>NomoStop<cr>", { desc = "NomoStop" })
      end,
    },
    event = "VeryLazy",
    init = function()
      vim.g.lualine_laststatus = vim.o.laststatus
      if vim.fn.argc(-1) > 0 then
        vim.o.statusline = " "
      else
        vim.o.laststatus = 0
      end
    end,
    opts = function()
      local lualine_require = require("lualine_require")
      lualine_require.require = require

      local icons = require("config.util").defaults.icons

      vim.o.laststatus = vim.g.lualine_laststatus

      return {
        options = {
          theme = "auto",
          globalstatus = true,
          disabled_filetypes = { statusline = { "dashboard", "alpha", "starter" } },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch" },
          lualine_c = {
            root_dir(),
            {
              "diagnostics",
              symbols = {
                error = icons.diagnostics.Error,
                warn = icons.diagnostics.Warn,
                info = icons.diagnostics.Info,
                hint = icons.diagnostics.Hint,
              },
            },
            {
              "filetype",
              icon_only = true,
              separator = "",
              padding = { left = 1, right = 0 },
            },
            { pretty_path() },
          },
          lualine_x = {
            {
              function()
                return require("noice").api.status.command.get()
              end,
              cond = function()
                return package.loaded["noice"] and require("noice").api.status.command.has()
              end,
              color = fg("Statement"),
            },
            {
              function()
                return require("noice").api.status.mode.get()
              end,
              cond = function()
                return package.loaded["noice"] and require("noice").api.status.mode.has()
              end,
              color = fg("Constant"),
            },
            {
              function()
                return "  " .. require("dap").status()
              end,
              cond = function()
                return package.loaded["dap"] and require("dap").status() ~= ""
              end,
              color = fg("Debug"),
            },
            {
              require("lazy.status").updates,
              cond = require("lazy.status").has_updates,
              color = fg("Special"),
            },
            {
              "diff",
              symbols = {
                added = icons.git.added,
                modified = icons.git.modified,
                removed = icons.git.removed,
              },
              source = function()
                local gitsigns = vim.b.gitsigns_status_dict
                if gitsigns then
                  return {
                    added = gitsigns.added,
                    modified = gitsigns.changed,
                    removed = gitsigns.removed,
                  }
                end
              end,
            },
          },
          lualine_y = {
            { "progress", separator = " ",                  padding = { left = 1, right = 0 } },
            { "location", padding = { left = 0, right = 1 } },
          },
          lualine_z = {
            require("nomodoro").status,
          },
        },
        extensions = { "neo-tree", "lazy" },
      }
    end,
  },
}
