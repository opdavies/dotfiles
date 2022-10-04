SHOULD_RELOAD_TELESCOPE = true

local reloader = function()
  if SHOULD_RELOAD_TELESCOPE then
    RELOAD "plenary"
    RELOAD "telescope"
    RELOAD "opdavies.telescope.setup"
  end
end

local themes = require "telescope.themes"

local M = {}

function M.current_buf()
  local opts = {
    sorting_strategy = "ascending",
    previewer = false,
  }

  require("telescope.builtin").current_buffer_fuzzy_find(opts)
end

M.diagnostics = function()
  local theme = require("telescope.themes").get_dropdown {
    previewer = false,
  }

  require("telescope.builtin").diagnostics(theme)
end

function M.lsp_document_symbols()
  local theme = require("telescope.themes").get_dropdown {
    previewer = false,
  }

  require("telescope.builtin").lsp_document_symbols(theme)
end

function M.edit_neovim()
  local opts = {
    cwd = "~/.config/nvim",
    find_command = { "rg", "--no-ignore", "--files", "--follow" },
    path_display = { "shorten" },
    prompt_title = "~ dotfiles ~",
    no_ignore = true,

    layout_strategy = "flex",
    layout_config = {
      height = 0.8,
      prompt_position = "top",
      width = 0.9,

      horizontal = {
        width = { padding = 0.15 },
      },
      vertical = {
        preview_height = 0.75,
      },
    },
  }

  require("telescope.builtin").find_files(opts)
end

function M.edit_zsh()
  local opts = {
    cwd = "~/.config/zsh",
    path_display = { "shorten" },
    prompt_title = "~ zsh ~",
    no_ignore = true,

    layout_strategy = "flex",
    layout_config = {
      height = 0.8,
      prompt_position = "top",
      width = 0.9,

      horizontal = {
        width = { padding = 0.15 },
      },
      vertical = {
        preview_height = 0.75,
      },
    },
  }

  require("telescope.builtin").find_files(opts)
end

function M.file_browser()
  local opts = {
    cwd = vim.fn.expand "%:p:h",
    sorting_strategy = "ascending",
  }

  require("telescope").extensions.file_browser.file_browser(opts)
end

function M.fd()
  local opts = themes.get_ivy {
    file_ignore_patterns = { ".git/" },
    hidden = true,
    no_ignore = true,
  }

  require("telescope.builtin").find_files(opts)
end

function M.git_files()
  local opts = themes.get_ivy {
    file_ignore_patterns = { ".git/", "vendor" },
    hidden = true,
    no_ignore = true,
  }

  require("telescope.builtin").git_files(opts)
end

function M.live_grep()
  require("telescope.builtin").live_grep {
    file_ignore_patterns = { ".git/" },
    hidden = true,
    no_ignore = true,
    sorting_strategy = "ascending",
  }
end

return setmetatable({}, {
  __index = function(_, k)
    reloader()

    if M[k] then
      return M[k]
    else
      return require("telescope.builtin")[k]
    end
  end,
})