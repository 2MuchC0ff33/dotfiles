local tsv = require("lib.tsv")

local M = {}

---@param row table<integer, string>
---@return boolean|nil
---@return string|nil
function M.validate_row(row)
  if type(row) ~= "table" then
    return nil, "row must be a table"
  end
  if #row ~= 7 then
    return nil, "expected 7 fields, found " .. #row
  end
  if not tostring(row[3]):match("^-?%d+$") then
    return nil, "timestamp must be an integer"
  end
  return true
end

---@param path string
---@return boolean|nil
---@return integer|string|nil
function M.validate_output(path)
  local f, err = io.open(path, "r")
  if f == nil then
    return nil, err
  end
  local text = f:read("*a")
  f:close()
  local rows, perr = tsv.parse(text, 7, path)
  if rows == nil then
    return nil, perr
  end
  for i, row in ipairs(rows) do
    local ok, verr = M.validate_row(row)
    if not ok then
      return nil, path .. ":" .. i .. ": " .. verr
    end
  end
  return true, #rows
end

---@param path string
function M.main(path)
  local ok, err = M.validate_output(path)
  if not ok then
    io.stderr:write("normalize_events: INPUT_INVALID: " .. tostring(err) .. "\n")
    os.exit(3)
  end
end

return M
