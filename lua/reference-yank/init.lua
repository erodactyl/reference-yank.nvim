local M = {}

local defaults = {
  keymap = 'yr',
  clipboard_register = '+',
  prefix = '@',
  separator = ' ',
  line_prefix = 'L',
  relative_path = true,
  highlight = {
    enabled = true,
    group = 'IncSearch',
    timeout = 150,
  },
  notify = true,
}

local config = vim.deepcopy(defaults)
local namespace = vim.api.nvim_create_namespace 'reference-yank'

local function highlight_range(start_line, end_line)
  if not config.highlight.enabled then
    return
  end

  local bufnr = vim.api.nvim_get_current_buf()

  vim.schedule(function()
    vim.api.nvim_buf_clear_namespace(bufnr, namespace, 0, -1)

    for line = start_line, end_line do
      vim.api.nvim_buf_add_highlight(bufnr, namespace, config.highlight.group, line - 1, 0, -1)
    end

    vim.defer_fn(function()
      if vim.api.nvim_buf_is_valid(bufnr) then
        vim.api.nvim_buf_clear_namespace(bufnr, namespace, 0, -1)
      end
    end, config.highlight.timeout)
  end)
end

local function current_path()
  if config.relative_path then
    return vim.fn.expand '%:.'
  end

  return vim.fn.expand '%:p'
end

function M.yank()
  local path = current_path()
  local start_line = vim.fn.line 'v'
  local end_line = vim.fn.line '.'

  if start_line > end_line then
    start_line, end_line = end_line, start_line
  end

  local line_reference = config.line_prefix .. start_line
  if start_line ~= end_line then
    line_reference = line_reference .. '-' .. end_line
  end

  local reference = config.prefix .. path .. config.separator .. line_reference

  vim.fn.setreg(config.clipboard_register, reference)
  highlight_range(start_line, end_line)

  if config.notify then
    vim.notify('Yanked ' .. reference)
  end
end

function M.setup(opts)
  config = vim.tbl_deep_extend('force', defaults, opts or {})

  if config.keymap ~= false then
    vim.keymap.set({ 'n', 'x' }, config.keymap, M.yank, { desc = '[Y]ank file [R]eference' })
  end
end

return M
