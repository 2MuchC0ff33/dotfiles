local M = {}

local MAX_PATH = 4096

---@param line string
---@return string|nil
---@return string|nil
---@return string|nil
---@return string|nil
function M.parse_line(line)
  if type(line) ~= "string" then
    return nil, nil, nil, "line must be a string"
  end
  local crc, size, path = line:match("^(%d+)%s+(%d+)%s+(.+)$")
  if crc == nil then
    return nil, nil, nil, "malformed cksum line"
  end
  if #path > MAX_PATH then
    return nil, nil, nil, "path too long"
  end
  if path:sub(1, 1) == "/" then
    return nil, nil, nil, "absolute paths are not allowed in manifests"
  end
  if path:find("%.%.") ~= nil then
    return nil, nil, nil, "parent traversal is not allowed in manifests"
  end
  if path:find("[%c]") ~= nil then
    return nil, nil, nil, "control characters are not allowed in paths"
  end
  return crc, size, path
end

---@param line string
---@return string|nil
---@return string|nil
function M.format_line(line)
  local crc, size, path, err = M.parse_line(line)
  if crc == nil then
    return nil, err
  end
  return crc .. " " .. size .. " " .. path
end

---@param path string
---@return table<integer, table<string, string>>|nil
---@return string|nil
function M.read_manifest(path)
  local f, err = io.open(path, "r")
  if f == nil then
    return nil, err
  end
  local text = f:read("*a")
  f:close()

  local entries = {}
  local line_no = 0
  for line in text:gmatch("[^\n]+") do
    line_no = line_no + 1
    if line:match("^%s*$") == nil and line:sub(1, 1) ~= "#" then
      local crc, size, rel, perr = M.parse_line(line)
      if crc == nil then
        return nil, path .. ":" .. line_no .. ": " .. tostring(perr)
      end
      entries[#entries + 1] = { crc = crc, size = size, path = rel }
    end
  end
  return entries
end

---@param entry table<string, string>
---@param actual string
---@return boolean
---@return string|nil
function M.matches(entry, actual)
  local crc, size, path, err = M.parse_line(actual)
  if crc == nil then
    return false, err
  end
  if crc ~= entry.crc or size ~= entry.size or path ~= entry.path then
    return false, "checksum mismatch for " .. entry.path
  end
  return true
end

return M
