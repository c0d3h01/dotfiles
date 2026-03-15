return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    cmd = { "CodexAgent" },
    keys = {
      { "<leader>ac", "<cmd>CodexAgent<cr>", mode = { "n", "t" }, desc = "Codex agent" },
    },
    opts = {
      start_in_insert = true,
      insert_mappings = true,
      persist_size = true,
      persist_mode = true,
      direction = "float",
      float_opts = {
        border = "rounded",
      },
    },
    config = function(_, opts)
      require("toggleterm").setup(opts)

      local Terminal = require("toggleterm.terminal").Terminal

      local codex = Terminal:new({
        cmd = "codex",
        hidden = true,
        direction = "float",
        close_on_exit = false,
      })

      local function toggle_codex()
        if vim.fn.executable("codex") == 0 then
          vim.notify("`codex` is not installed or not in PATH", vim.log.levels.ERROR)
          return
        end
        codex:toggle()
      end

      vim.api.nvim_create_user_command("CodexAgent", toggle_codex, {
        desc = "Open Codex agent terminal",
      })
    end,
  },
}
