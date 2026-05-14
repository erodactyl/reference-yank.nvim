if vim.g.loaded_reference_yank then
  return
end

vim.g.loaded_reference_yank = true

require('reference-yank').setup()
