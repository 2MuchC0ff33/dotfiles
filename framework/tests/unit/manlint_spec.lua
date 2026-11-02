local h = require("tests.lib.harness")
local manlint = require("lib.manlint")

local function write_temp(name, text)
  local path = "work/" .. name
  local f = assert(io.open(path, "w"))
  f:write(text)
  f:close()
  return path
end

h.describe("manlint", function()
  h.it("accepts the framework page", function()
    local ok, err = manlint.validate("man/framework.1")
    h.ok(ok, err)
  end)

  h.it("rejects a missing .TH", function()
    local path = write_temp("bad1.1", ".SH NAME\nx \\- y\n.SH DESCRIPTION\ntext\n")
    local ok, err = manlint.validate(path)
    h.eq(ok, nil)
    h.ok(err:match("missing %.TH"))
    os.remove(path)
  end)

  h.it("rejects an unknown macro", function()
    local path = write_temp("bad2.1", '.TH X 1 "2026-11-01" "x" "x"\n.SH NAME\nx \\- y\n.BOGUS x\n')
    local ok, err = manlint.validate(path)
    h.eq(ok, nil)
    h.ok(err:match("unknown macro %.BOGUS"))
    os.remove(path)
  end)

  h.it("rejects an empty NAME", function()
    local path = write_temp("bad3.1", '.TH X 1 "2026-11-01" "x" "x"\n.SH NAME\n.SH DESCRIPTION\ntext\n')
    local ok, err = manlint.validate(path)
    h.eq(ok, nil)
    h.ok(err:match("empty NAME"))
    os.remove(path)
  end)

  h.it("rejects a missing body", function()
    local path = write_temp("bad4.1", '.TH X 1 "2026-11-01" "x" "x"\n.SH NAME\nx \\- y\n')
    local ok, err = manlint.validate(path)
    h.eq(ok, nil)
    h.ok(err:match("missing %.SH SYNOPSIS"))
    os.remove(path)
  end)
end)
