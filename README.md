# mdview.nvim

A simple Neovim plugin for previewing Markdown files in a floating window or your browser, with live updates and scroll synchronization.

## Features

- Live preview of Markdown files.
- Scroll synchronization between Neovim and the browser.
- Floating window preview inside Neovim using `w3m`.
- Open the preview in your default browser.
- Dark mode support (toggled with the `t` key).
- Yank the rendered HTML to the clipboard.

## Dependencies

- `node`
- `pandoc`
- `w3m` (for the floating window preview)
- `curl`

## Installation

Using `packer.nvim`:

```lua
use {
  'your-username/mdview.nvim',
  run = 'npm install',
}
```

## Usage

- `:MDView` - Start the preview for the current Markdown file.
- `:MDStop` - Stop the preview.

The preview will open in a floating window. You can also open it in your browser by pressing `o` in the preview window.

### Keymaps (in the preview window)

- `q` - Close the preview window.
- `o` - Open the preview in your default browser.
- `t` - Toggle between light and dark themes.
- `y` - Yank the rendered HTML to the system clipboard.

## How it works

The plugin starts a local web server that renders the Markdown file using `pandoc`. The preview is displayed in a floating window using `w3m`, or in your browser. A WebSocket connection is used to enable live updates and scroll synchronization between Neovim and the browser.
