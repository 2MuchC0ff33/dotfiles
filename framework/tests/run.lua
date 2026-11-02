local harness = require("tests.lib.harness")

for i = 1, #arg do
  local file = arg[i]
  local chunk, err = loadfile(file)
  if chunk == nil then
    io.write("FAIL load ", file, " :: ", tostring(err), "\n")
    os.exit(1)
  end
  local ok, rerr = pcall(chunk)
  if not ok then
    io.write("FAIL run ", file, " :: ", tostring(rerr), "\n")
    os.exit(1)
  end
end

harness.done()
