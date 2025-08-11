
# mdview.nvim Guide

This guide provides a detailed overview of how to use mdview.nvim.

## Installation

First, make sure you have [Node.js](https://nodejs.org/) installed on your system.

Then, install mdview.nvim using your favorite plugin manager.

### [Packer](https://github.com/wbthomason/packer.nvim)

```lua
use {
  'anvnd/mdview.nvim',
  run = 'npm install',
}
```

### [vim-plug](https://github.com/junegunn/vim-plug)

```vim
Plug 'anvnd/mdview.nvim', { 'do': 'npm install' }
```

## Usage

Once you have installed mdview.nvim, you can use the following commands:

- `:MdviewStart`: Start the Markdown preview.
- `:MdviewStop`: Stop the Markdown preview.

You can also use the `<leader>md` mapping to start the preview.

### Example

1. Open a Markdown file in Neovim.
2. Run `:MdviewStart` or use the `<leader>md` mapping.
3. A new browser window or tab will open with a live preview of your Markdown file.
4. As you make changes to the file in Neovim, the preview will update automatically.

## Configuration

You can configure mdview.nvim by passing a setup function to the `setup` method.

```lua
require('mdview').setup {
  -- Your configuration options here
}
```

See the [README.md](README.md) for a list of available configuration options.
