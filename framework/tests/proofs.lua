local literal = require("lib.literal")
local refine = require("lib.refine")

local failed = 0

for i = 1, #arg do
  local path = arg[i]
  local f = assert(io.open(path, "r"))
  local text = f:read("*a")
  f:close()

  local proof, perr = literal.parse(text, path)
  if proof == nil then
    io.write("FAIL parse ", path, " :: ", perr, "\n")
    failed = failed + 1
  else
    local ok, verr = refine.validate(proof, ".")
    if not ok then
      io.write("FAIL validate ", path, " :: ", verr, "\n")
      failed = failed + 1
    else
      io.write("PASS ", path, "\n")
    end
  end
end

if failed > 0 then
  os.exit(5)
end
