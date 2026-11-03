local h = require("tests.lib.harness")
local lcg = require("tests.lib.lcg")
local normalize = require("lib.stages.normalize_events")

local function row(n, ts)
  return {
    "event-" .. n,
    "kind-" .. (n % 5),
    tostring(ts),
    "actor-" .. n,
    "session-" .. n,
    "source-" .. (n % 3),
    '{"n":' .. n .. "}",
  }
end

local function write_rows(path, rows)
  local f = assert(io.open(path, "w"))
  for i = 1, #rows do
    f:write(table.concat(rows[i], "\t"), "\n")
  end
  f:close()
end

h.describe("normalize_events property", function()
  h.it("accepts generated valid rows", function()
    lcg.seed(20261101)
    local rows = {}
    for n = 1, 250 do
      rows[n] = row(n, lcg.int(2000001) - 1000001)
    end
    local path = "work/normalize.prop.tsv"
    write_rows(path, rows)
    local ok, count = normalize.validate_output(path)
    h.ok(ok, count)
    h.eq(count, 250)
    os.remove(path)
  end)

  h.it("rejects a row with one field removed", function()
    local rows = { row(1, 0) }
    table.remove(rows[1], 4)
    local ok, err = normalize.validate_row(rows[1])
    h.eq(ok, nil)
    h.ok(err:match("expected 7 fields"))
  end)

  h.it("rejects a non-integer timestamp", function()
    local rows = { row(2, 0) }
    rows[1][3] = "1e3"
    local ok, err = normalize.validate_row(rows[1])
    h.eq(ok, nil)
    h.ok(err:match("integer"))
  end)

  h.it("accepts boundary timestamps", function()
    for _, ts in ipairs({ "0", "-1", "2147483647", "-2147483648" }) do
      local rows = { row(3, 0) }
      rows[1][3] = ts
      local ok, err = normalize.validate_row(rows[1])
      h.ok(ok, err)
    end
  end)
end)
