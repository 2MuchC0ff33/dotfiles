local h = require("tests.lib.harness")
local errors = require("lib.errors")

h.describe("errors", function()
  h.it("maps known classes", function()
    h.eq(errors.exit_code("INPUT_INVALID"), 3)
    h.eq(errors.exit_code("ENV_MISSING"), 4)
    h.eq(errors.exit_code("PROOF_FAILED"), 5)
    h.eq(errors.exit_code("EDGE_FAILED"), 1)
  end)

  h.it("rejects unknown classes", function()
    h.fails(function()
      errors.exit_code("NOT_A_CLASS")
    end)
  end)

  h.it("formats a full message", function()
    h.eq(
      errors.format("INPUT_INVALID", "stage", "work/a.tsv", "7 fields", "5 fields", "fix input"),
      "stage: INPUT_INVALID: work/a.tsv: expected 7 fields: observed 5 fields; hint: fix input"
    )
  end)

  h.it("formats without artifact or hint", function()
    local msg = errors.format("ENV_MISSING", "env", nil, "lua5.4", "absent")
    h.eq(msg, "env: ENV_MISSING: expected lua5.4: observed absent")
  end)
end)
