local cutlass = require("cutlass")
local get_mappings = function(mode)
  local mappings = {}
  for _, mapping in ipairs(vim.api.nvim_get_keymap(mode)) do
    mappings[mapping.lhs] = mapping
  end

  return mappings
end

describe("Options should be set correctly", function()
  it("should take default values", function()
    vim.cmd("mapclear")
    cutlass.setup()
    assert(cutlass.options.cut_key == nil)
  end)
end)

describe("Overrides delete and change mappings", function()
  it("should map change and delete keys", function()
    vim.cmd("mapclear")
    cutlass.setup()
    local mappings = get_mappings("n")

    assert(mappings["c"])
    assert.are.equals('"_d', mappings["d"].rhs)
    assert(mappings["D"].silent)
    assert(mappings["x"].noremap)
  end)

  it("should map change and delete keys in x mode", function()
    vim.cmd("mapclear")
    cutlass.setup()
    local mappings = get_mappings("x")

    assert(mappings["c"])
    assert.are.equals('"_d', mappings["d"].rhs)
    assert(mappings["D"].silent)
    assert(mappings["x"].noremap)
  end)

  it("should not override already mapped keys", function()
    vim.cmd("mapclear")
    vim.api.nvim_set_keymap("n", "d", "gv", { noremap = true, silent = true })
    cutlass.setup()

    local mappings = get_mappings("n")

    assert.are.equals("gv", mappings["d"].rhs)
  end)
end)

describe("Overrides select mode", function()
  it("should overrides select mode", function()
    vim.cmd("mapclear")
    cutlass.setup()
    local mappings = get_mappings("s")

    assert(mappings["a"])
    assert.are.equals('<C-O>"_ca', mappings["a"].rhs)
    assert(mappings["Z"])
    assert.are.equals('<C-O>"_cZ', mappings["Z"].rhs)

    assert(mappings["\\"])
    assert.are.equals('<C-O>"_c\\\\', mappings["\\"].rhs)
    assert(mappings["|"])
    assert.are.equals('<C-O>"_c|', mappings["|"].rhs)

    assert.are.equals('<C-O>"_c', mappings["<BS>"].rhs)
  end)
end)

describe("Create cut mappings", function()
  it("should map cut keys if setup", function()
    vim.cmd("mapclear")
    cutlass.setup({
      cut_key = "m",
    })
    local mappings = get_mappings("n")

    assert(mappings["m"])
    assert(mappings["m"].rhs, "d")
    assert(mappings["mm"])
    assert(mappings["mm"].rhs, "dd")
  end)
end)

describe("Exclude option", function()
  it("should not map excluded mapping", function()
    vim.cmd("mapclear")
    cutlass.setup({
      exclude = { "ns", "nS", "sa", "s<bs>", "s<space>" },
    })
    local mappings = get_mappings("n")

    assert(nil == mappings["s"])
    assert(nil == mappings["S"])

    mappings = get_mappings("s")
    assert(nil == mappings["a"])
    assert(nil == mappings["<bs>"])
    assert(nil == mappings["<space>"])
  end)
end)

describe("Registers option", function()
  it("should not map excluded mapping", function()
    vim.cmd("mapclear")
    cutlass.setup({
      registers = {
        select = "s",
        delete = "d",
        change = "c",
      },
    })
    local mappings = get_mappings("n")
    assert('"dd', mappings["d"].rhs)
    assert('"cc', mappings["c"].rhs)

    mappings = get_mappings("s")
    assert.are.equals('<C-O>"scd', mappings["d"].rhs)
  end)
end)
