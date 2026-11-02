local M = { passed = 0, failed = 0, current = "" }

function M.describe(name, fn)
  M.current = name
  fn()
end

function M.it(name, fn)
  local ok, err = pcall(fn)
  if ok then
    M.passed = M.passed + 1
    io.write("PASS ", M.current, " :: ", name, "\n")
  else
    M.failed = M.failed + 1
    io.write("FAIL ", M.current, " :: ", name, " :: ", tostring(err), "\n")
  end
end

function M.eq(a, b, msg)
  if a ~= b then
    error((msg or "eq failed") .. ": expected " .. tostring(b) .. ", got " .. tostring(a), 2)
  end
end

function M.ok(v, msg)
  if not v then
    error(msg or "expected truthy", 2)
  end
end

function M.fails(fn, msg)
  local ok = pcall(fn)
  if ok then
    error(msg or "expected failure", 2)
  end
end

function M.done()
  io.write(string.format("TOTAL pass=%d fail=%d\n", M.passed, M.failed))
  if M.failed > 0 then
    os.exit(1)
  end
end

return M
