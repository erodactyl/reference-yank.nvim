# reference-yank.nvim

Yank file references from Neovim in a format that tools like opencode can parse.

By default, `yr` copies the current file path and selected line numbers to your system clipboard:

```text
@path/to/file.lua L29
@path/to/file.lua L29-L32
```

It works in normal mode for the current line and visual mode for a selected line range. The referenced lines flash with a yank-style highlight so the mapping feels like a normal `y` operation.

## Installation

With [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  'erodactyl/reference-yank.nvim',
}
```

For local development:

```lua
{
  dir = '~/.config/reference-yank.nvim',
}
```

The plugin sets up the default `yr` mapping automatically.

## Usage

Place your cursor on a line and press:

```text
yr
```

To yank a multi-line reference, visually select lines and press:

```text
yr
```

Examples:

```text
@lua/reference-yank/init.lua L42
@lua/reference-yank/init.lua L42-L47
```

## Configuration

Call `setup()` if you want to change the defaults:

```lua
require('reference-yank').setup {
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
```

To define your own mapping:

```lua
require('reference-yank').setup { keymap = false }

vim.keymap.set({ 'n', 'x' }, '<leader>yr', function()
  require('reference-yank').yank()
end, { desc = 'Yank file reference' })
```

## Defaults

- Uses relative file paths from the current working directory.
- Copies to the system clipboard register `+`.
- Formats references as `@file Lstart` or `@file Lstart-Lend`.
- Highlights the referenced line range briefly.
