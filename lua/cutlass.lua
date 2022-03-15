local cutlass = {}

local function with_defaults(options)
  local flip = function(t)
    local flipped = {}
    for _, value in pairs(t) do
      flipped[value] = true
    end

    return flipped
  end

  return {
    cut_key = options.cut_key or nil,
    override_del = options.override_del or nil,
    exclude = options.exclude and flip(options.exclude) or {},
  }
end

local keymap_opts = { noremap = true, silent = true }
local map = vim.api.nvim_set_keymap

function cutlass.setup(options)
  cutlass.options = with_defaults(options or {})

  cutlass.override_delete_and_change_bindings()
  cutlass.override_select_bindings()
  cutlass.create_cut_bindings()
end

function cutlass.override_delete_and_change_bindings()
  local overrides = {
    { lhs = "c", rhs = '"_c', modes = { "n", "x" } },
    { lhs = "cc", rhs = '"_S', modes = { "n" } },
    { lhs = "C", rhs = '"_C', modes = { "n", "x" } },
    { lhs = "s", rhs = '"_s', modes = { "n", "x" } },
    { lhs = "S", rhs = '"_S', modes = { "n", "x" } },
    { lhs = "d", rhs = '"_d', modes = { "n", "x" } },
    { lhs = "dd", rhs = '"_dd', modes = { "n" } },
    { lhs = "D", rhs = '"_D', modes = { "n", "x" } },
    { lhs = "x", rhs = '"_x', modes = { "n", "x" } },
    { lhs = "X", rhs = '"_X', modes = { "n", "x" } },
  }

  for _, override in ipairs(overrides) do
    for _, mode in ipairs(override.modes) do
      if not cutlass.options.exclude[mode .. override.lhs] and vim.fn.maparg(override.lhs, mode) == "" then
        map(mode, override.lhs, override.rhs, keymap_opts)
      end
    end
  end

  if cutlass.options.override_del == true then
    map("n", "<Del>", '"_x', keymap_opts)
    map("x", "<Del>", '"_x', keymap_opts)
  end
end

function cutlass.override_select_bindings()
  local escape_rhs = function(char)
    return char == "\\" and "\\" .. char or char
  end

  -- Add a map for every printable character to copy to black hole register
  for char_nr = 33, 126 do
    local char = vim.fn.nr2char(char_nr)
    if not cutlass.options.exclude["s" .. char] then
      map("s", char, '<c-o>"_c' .. escape_rhs(char), keymap_opts)
    end
  end

  if not cutlass.options.exclude["s<bs>"] then
    map("s", "<bs>", '<c-o>"_c', keymap_opts)
  end

  if not cutlass.options.exclude["s<space>"] then
    map("s", "<space>", '<c-o>"_c<space>', keymap_opts)
  end
end

function cutlass.create_cut_bindings()
  if nil == cutlass.options.cut_key then
    return
  end

  map("n", cutlass.options.cut_key, "d", keymap_opts)
  map("x", cutlass.options.cut_key, "d", keymap_opts)
  map("n", cutlass.options.cut_key .. cutlass.options.cut_key, "dd", keymap_opts)
  map("n", string.upper(cutlass.options.cut_key), "D", keymap_opts)
end
cutlass.options = nil

return cutlass
