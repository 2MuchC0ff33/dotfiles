local h = require("tests.lib.harness")
local json = require("lib.json")

h.describe("json", function()
  h.it("sorts object keys", function()
    h.eq(json.encode({ b = 2, a = 1 }), '{"a":1,"b":2}')
  end)

  h.it("encodes arrays", function()
    h.eq(json.encode({ 3, 1, 2 }), "[3,1,2]")
  end)

  h.it("encodes nested values", function()
    h.eq(json.encode({ a = { 1, 2 }, b = true, c = false }), '{"a":[1,2],"b":true,"c":false}')
  end)

  h.it("escapes control characters", function()
    local out = json.encode({ s = 'a"b\\c\n' })
    h.eq(out, '{"s":"a\\"b\\\\c\\n"}')
  end)

  h.it("rejects non-finite numbers", function()
    h.fails(function()
      json.encode({ n = 0 / 0 })
    end)
  end)

  h.it("rejects mixed numeric keys", function()
    h.fails(function()
      json.encode({ [1] = "a", [3] = "c" })
    end)
  end)
end)
