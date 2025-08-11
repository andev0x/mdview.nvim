
<div align="center">
    <h1> mdview.nvim </h1>
</div>

----

<p align="center">
  <a href="https://github.com/andev0x/mdview.nvim/actions/workflows/lint.yml">
    <img
      alt="lint"
      src="https://github.com/andev0x/mdview.nvim/actions/workflows/lint.yml/badge.svg"
    />
  </a>
  <a href="https://github.com/andev0x/mdview.nvim/blob/main/LICENSE">
    <img
      alt="license"
      src="https://img.shields.io/github/license/andev0x/mdview.nvim?style=flat-square"
    />
  </a>
  <a href="https://github.com/andev0x/mdview.nvim/issues">
    <img
      alt="issues"
      src="https://img.shields.io/github/issues/andev0x/mdview.nvim?style=flat-square"
    />
  </a>
  <a href="https://github.com/andev0x/mdview.nvim/stargazers">
    <img
      alt="stars"
      src="https://img.shields.io/github/stars/andev0x/mdview.nvim?style=flat-square"
    />
  </a>
</p>

A simple Neovim plugin for previewing Markdown files in a floating window or your browser, with live updates and scroll synchronization.

## Features

- Live preview of Markdown files.
- Scroll synchronization between Neovim and the browser.
- Floating window preview inside Neovim using `w3m`.
- Open the preview in your default browser.
- Dark mode support (toggled with the `t` key).
- Yank the rendered HTML to the clipboard.

## Demo
<div align="center">
    <img src="https://raw.githubusercontent.com/andev0x/description-image-archive/refs/heads/main/mdview.nvim/0811.gif" width="100%"/>"
</div>

## Dependencies

- `node`
- `pandoc`
- `w3m` (for the floating window preview)
- `curl`

## Installation

Using `packer.nvim`:

```lua
use {
  'andev0x/mdview.nvim',
  run = 'npm install',
}
```

Using `lazy.nvim`:

```lua
{
  'andev0x/mdview.nvim',
  build = 'npm install',
  config = function()
    require('mdview').setup()
  end,
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

## Configuration

You can configure the plugin by passing a setup function to the `setup` method.

```lua
require('mdview').setup({
  -- The port to use for the web server.
  port = 8080,
  -- The host to use for the web server.
  host = '127.0.0.1',
  -- The template to use for the HTML output.
  -- You can use the following placeholders:
  --   - `{{title}}` - The title of the document.
  --   - `{{body}}` - The body of the document.
  --   - `{{theme}}` - The theme of the document (light or dark).
  --   - `{{ws_address}}` - The address of the WebSocket server.
  template = '<html>...</html>',
  -- The dark theme template.
  template_dark = '<html>...</html>',
  -- The command to use for opening the browser.
  browser_cmd = 'xdg-open',
  -- The command to use for yanking the HTML to the clipboard.
  yank_cmd = 'xclip -selection clipboard',
})
```

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## License

[MIT](LICENSE)
