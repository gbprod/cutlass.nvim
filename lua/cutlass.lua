local cutlass = {}

local function with_defaults(options)
  return {
    cut_key = options.cut_key or nil,
    override_del = options.override_del or nil,
  }
end

local keymap_opts = { noremap = true, silent = true }

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
      if vim.fn.maparg(override.lhs, mode) == "" then
        vim.api.nvim_set_keymap(mode, override.lhs, override.rhs, keymap_opts)
      end
    end
  end

  if cutlass.options.override_del == true then
    vim.api.nvim_set_keymap("n", "<Del>", '"_x', { noremap = true })
    vim.api.nvim_set_keymap("x", "<Del>", '"_x', { noremap = true })
  end
end

function cutlass.override_select_bindings()
  local escape_rhs = function(char)
    return char == "\\" and "\\" .. char or char
  end

  -- Add a map for every printable character to copy to black hole register
  for char_nr = 33, 126 do
    local char = vim.fn.nr2char(char_nr)
    vim.api.nvim_set_keymap("s", char, '<c-o>"_c' .. escape_rhs(char), keymap_opts)
  end

  vim.api.nvim_set_keymap("s", "<bs>", '<c-o>"_c', keymap_opts)
  vim.api.nvim_set_keymap("s", "<space>", '<c-o>"_c<space>', keymap_opts)
end

function cutlass.create_cut_bindings()
  if nil == cutlass.options.cut_key then
    return
  end

  vim.api.nvim_set_keymap("n", cutlass.options.cut_key, "d", keymap_opts)
  vim.api.nvim_set_keymap("x", cutlass.options.cut_key, "d", keymap_opts)
  vim.api.nvim_set_keymap("n", cutlass.options.cut_key .. cutlass.options.cut_key, "dd", keymap_opts)
  vim.api.nvim_set_keymap("n", string.upper(cutlass.options.cut_key), "D", keymap_opts)
end
cutlass.options = nil

return cutlass
