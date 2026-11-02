local h = require("tests.lib.harness")
local literal = require("lib.literal")

local function reject(text, pattern)
  local value, err = literal.parse(text, "spec")
  h.eq(value, nil)
  h.ok(err:match(pattern), "unexpected error: " .. tostring(err))
end

h.describe("literal", function()
  h.it("parses tables", function()
    local t, err = literal.parse('return { a = 1, b = { 1, 2, 3 }, c = { ["k"] = "v" }, d = true, e = -7 }', "spec")
    h.ok(t, err)
    h.eq(t.a, 1)
    h.eq(t.b[3], 3)
    h.eq(t.c.k, "v")
    h.eq(t.d, true)
    h.eq(t.e, -7)
  end)

  h.it("rejects calls", function()
    reject("return { f() }", "unexpected name f")
  end)

  h.it("rejects concatenation", function()
    reject('return { "a" .. "b" }', "expected , or }")
  end)

  h.it("rejects long strings", function()
    reject("return { [[x]] }", "unexpected character %[")
  end)

  h.it("rejects trailing input", function()
    reject("return { 1 } 2", "trailing input")
  end)

  h.it("rejects nil values", function()
    reject("return { nil }", "nil is not allowed")
  end)

  h.it("rejects duplicate keys", function()
    reject("return { a = 1, a = 2 }", "duplicate key a")
  end)

  h.it("rejects missing return", function()
    reject("local x = 1", "expected return")
  end)

  h.it("rejects bad escapes", function()
    reject('return { "\\q" }', "invalid escape")
  end)
end)
