# ✂️ cutlass.nvim

![Lua](https://img.shields.io/badge/Made%20with%20Lua-blueviolet.svg?style=for-the-badge&logo=lua)
[![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/gbprod/cutlass.nvim/integration.yml?branch=main&style=for-the-badge)](https://github.com/gbprod/cutlass.nvim/actions/workflows/integration.yml)

Cutlass overrides the delete operations to actually just delete and not affect the current yank.

## ✨ Features

It overrides the following keys to always use the black hole register: `c`, `C`, `s`, `S`, `d`, `D`, `x`, `X`.

Note that if you have already mapped these keys to something else (like we do below with `x`) then it will not change it again.

## 🤔 Why would you want to do this?

See [here](http://vimcasts.org/blog/2013/11/registers-the-good-the-bad-and-the-ugly-parts/).
This plugin [already exists](https://github.com/svermeulen/vim-cutlass) in vimscript. I hope this version in lua will be more efficient :)

## ⚡️ Requirements

- Neovim >= 0.5.0

## 📦 Installation

Install the plugin with your preferred package manager:

### [packer](https://github.com/wbthomason/packer.nvim)

```lua
-- Lua
use({
  "gbprod/cutlass.nvim",
  config = function()
    require("cutlass").setup({
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    })
  end
})
```

### [vim-plug](https://github.com/junegunn/vim-plug)

```vim
" Vim Script
Plug 'gbprod/cutlass.nvim'
lua << EOF
  require("cutlass").setup({
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  })
EOF
```

## ⚙️ Configuration

Cutlass comes with the following defaults:

```lua
{
  cut_key = nil,
  override_del = nil,
  exclude = {},
}
```

### `cut_key`

Default : `nil`

After setting up this plugin, all of these operations will simply delete and not cut. However, you will still want to have a key for 'cut', which you can add by setting the `cut_key` value when setting up the plugin. (`m` or `x` are recommended)

This will create those bindings :

```vimscript
nnoremap m d
xnoremap m d
nnoremap mm dd
nnoremap M D
```

### `override_del`

Default : `nil`

By default, this plugin doesn't remap the `<Del>` key to use the blackhole register (and it will work as the old `x` key). By setting `override_del` to true, `<Del>` key will not cut any more and not afect your current yank.

### `exclude`

Default: `{}`

For some reason, you may doesn't want `cutlass` to override some keys, you can exclude mappings to be set by adding this to the exclude option using format `"{mode}{key}"`.

Eg. If you want to exclude `s` key in normal mode, sets `exclude` option to `{ "ns" }` ; If you want to exclude `<bs>` key in select mode, sets `exclude` option to `{ "s<bs>" }`.

## 🤝 Integration

<details>
<summary><b>svermeulen/vim-yoink</b></summary>

If you have [svermeulen/vim-yoink](https://github.com/svermeulen/vim-yoink) installed, it will work seemlessly as original [svermeulen/vim-cutlass](https://github.com/svermeulen/vim-cutlass). Just follow the [integration instructions](https://github.com/svermeulen/vim-yoink#integration-with-vim-cutlass).

</details>

<details>
<summary><b>ggandor/lightspeed.nvim</b></summary>

When you're using plugins like [ggandor/lightspeed.nvim](https://github.com/ggandor/lightspeed.nvim), you should not want cutlass to remap the `s` key. You can do this using the `exclude` option:

```lua
use({
  "gbprod/cutlass.nvim",
  config = function()
    require("cutlass").setup({
        exclude = { "ns", "nS" },
    })
  end
})
```

</details>

## 🎉 Credits

This plugin is a lua version of [svermeulen/vim-cutlass](https://github.com/svermeulen/vim-cutlass) (based off of [vim-easyclip](https://github.com/svermeulen/vim-easyclip) and also [Drew Neil's ideas](https://github.com/nelstrom/vim-cutlass))

Credit to [m00qek lua plugin template](https://github.com/m00qek/plugin-template.nvim)
