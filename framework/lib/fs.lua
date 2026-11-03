local M = {}

---@param path string
---@return boolean
function M.is_safe_relative(path)
  if type(path) ~= "string" or path == "" then
    return false
  end
  if path:sub(1, 1) == "/" then
    return false
  end
  if path:find("\0", 1, true) then
    return false
  end
  for part in path:gmatch("[^/]+") do
    if part == ".." then
      return false
    end
  end
  return true
end

---@param path string
---@return table<integer, string>|nil
---@return string|nil
function M.read_lines(path)
  local f, err = io.open(path, "r")
  if f == nil then
    return nil, err
  end
  local lines = {}
  for line in f:lines() do
    lines[#lines + 1] = line
  end
  f:close()
  return lines
end

---@param path string
---@param text string
---@return boolean|nil
---@return string|nil
function M.write_atomic(path, text)
  local tmp = path .. ".tmp"
  local f, err = io.open(tmp, "w")
  if f == nil then
    return nil, err
  end
  local ok, werr = f:write(text)
  f:close()
  if not ok then
    os.remove(tmp)
    return nil, werr
  end
  local rok, rerr = os.rename(tmp, path)
  if not rok then
    os.remove(tmp)
    return nil, rerr
  end
  return true
end

return M
