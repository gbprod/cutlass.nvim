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
    registers = vim.tbl_extend("force", {
      select = "_",
      delete = "_",
      change = "_",
    }, options.registers or {}),
  }
end

local keymap_opts = { noremap = true, silent = true }
local map = vim.keymap.set

function cutlass.setup(options)
  cutlass.options = with_defaults(options or {})

  cutlass.override_delete_and_change_bindings()
  cutlass.override_select_bindings()
  cutlass.create_cut_bindings()
end

function cutlass.override_delete_and_change_bindings()
  for _, mode in pairs({ "x", "n" }) do
    for _, lhs in pairs({ "c", "C", "s", "S" }) do
      if not cutlass.options.exclude[mode .. lhs] and vim.fn.maparg(lhs, mode) == "" then
        map(mode, lhs, string.format('"%s%s', cutlass.options.registers.change, lhs), keymap_opts)
      end
    end
    for _, lhs in pairs({ "d", "D", "x", "X" }) do
      if not cutlass.options.exclude[mode .. lhs] and vim.fn.maparg(lhs, mode) == "" then
        map(mode, lhs, string.format('"%s%s', cutlass.options.registers.delete, lhs), keymap_opts)
      end
    end
  end

  if cutlass.options.override_del == true then
    map("n", "<Del>", string.format('"%sx', cutlass.options.registers.delete), keymap_opts)
    map("x", "<Del>", string.format('"%sx', cutlass.options.registers.delete), keymap_opts)
  end
end

function cutlass.override_select_bindings()
  -- Add a map for every printable character to copy to black hole register
  for char_nr = 33, 126 do
    local char = vim.fn.nr2char(char_nr)
    if not cutlass.options.exclude["s" .. char] then
      map(
        "s",
        char,
        string.format('<c-o>"%sc%s', cutlass.options.registers.select, char == "\\" and "\\\\" or char),
        keymap_opts
      )
    end
  end

  if not cutlass.options.exclude["s<bs>"] then
    map("s", "<bs>", string.format('<c-o>"%sc', cutlass.options.registers.select), keymap_opts)
  end

  if not cutlass.options.exclude["s<space>"] then
    map("s", "<space>", string.format('<c-o>"%sc<space>', cutlass.options.registers.select), keymap_opts)
  end
end

function cutlass.create_cut_bindings()
  if nil == cutlass.options.cut_key then
    return
  end

  local keymap_opts_with_desc = function(desc)
    return vim.tbl_extend("force", keymap_opts, { desc = desc })
  end

  map("n", cutlass.options.cut_key, "d", keymap_opts_with_desc("Cut"))
  map("x", cutlass.options.cut_key, "d", keymap_opts_with_desc("Cut"))
  map("n", cutlass.options.cut_key .. cutlass.options.cut_key, "dd", keymap_opts_with_desc("Cut line"))
  map("n", string.upper(cutlass.options.cut_key), "D", keymap_opts_with_desc("Cut until EOL"))
end

return cutlass
