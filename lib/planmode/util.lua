local M = {}

function M.read_all(path)
  local file, err = io.open(path, "rb")
  if not file then error(err or ("cannot open " .. path)) end
  local data = file:read("*a")
  file:close()
  return data
end

function M.write_all(path, data)
  if path:sub(-4) == ".tmp" then error("unexpected temp path") end
  local tmp = path .. ".tmp"
  local file = io.open(tmp, "wb")
  if not file then error("cannot write " .. tmp) end
  file:write(data)
  file:close()
  local ok, err = os.rename(tmp, path)
  if not ok then error("cannot rename " .. tmp .. " to " .. path .. ": " .. tostring(err)) end
end

function M.split_lines(data)
  local lines = {}
  for line in data:gmatch("([^\n]*)\n?") do
    if line == "" and #lines > 0 and lines[#lines] == "" then break end
    lines[#lines + 1] = line
  end
  if data:sub(-1) == "\n" then table.remove(lines) end
  return lines
end

function M.join_lines(lines)
  return table.concat(lines, "\n") .. "\n"
end

function M.is_ascii(data)
  for i = 1, #data do
    local b = data:byte(i)
    if b >= 127 then return false, i end
  end
  return true
end

function M.secure_temp(path)
  local file = io.open(path, "wx")
  if file then file:close(); return true end
  return false
end

return M
