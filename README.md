# cutlass.nvim

[![Integration](https://github.com/gbprod/cutlass.nvim/actions/workflows/integration.yml/badge.svg)](https://github.com/gbprod/cutlass.nvim/actions/workflows/integration.yml)

Cutlass overrides the delete operations to actually just delete and not affect the current yank.

It achieves this by overriding the following keys to always use the black hole register: `c`, `cc`, `C`, `s`, `S`, `d`, `dd`, `D`, `x`, `X`. Note that if you have already mapped these keys to something else (like we do below with `x`) then it will not change it again.

## Why would you want to do this?

See [here](http://vimcasts.org/blog/2013/11/registers-the-good-the-bad-and-the-ugly-parts/).
This plugin [already exists](https://github.com/svermeulen/vim-cutlass) in vimscript. I hope this version in lua will be more efficient :)

## Usage

Requires neovim > 0.5.0.

Using [https://github.com/wbthomason/packer.nvim](packer):

```lua
use({
  "gbprod/cutlass.nvim",
  config = function()
    require("cutlass").setup({
        cut_key = "m"
    })
  end
})
```

## Configuration

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

## Integration

If you have [svermeulen/vim-yoink](https://github.com/svermeulen/vim-yoink) installed, it will work seemlessly as original [svermeulen/vim-cutlass](https://github.com/svermeulen/vim-cutlass). Just follow the [integration instructions](https://github.com/svermeulen/vim-yoink#integration-with-vim-cutlass).

## Credits

This plugin is a lua version of [svermeulen/vim-cutlass](https://github.com/svermeulen/vim-cutlass) (based off of [vim-easyclip](https://github.com/svermeulen/vim-easyclip) and also [Drew Neil's ideas](https://github.com/nelstrom/vim-cutlass))

Credit to [m00qek lua plugin template](https://github.com/m00qek/plugin-template.nvim)
