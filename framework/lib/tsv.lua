local M = {}

---@param text string
---@param expected integer|nil
---@param chunkname string|nil
---@return table<integer, table<integer, string>>|nil
---@return string|nil
function M.parse(text, expected, chunkname)
  chunkname = chunkname or "<tsv>"
  local rows = {}
  local line = 0
  for raw in (text .. "\n"):gmatch("(.-)\n") do
    line = line + 1
    if raw:find("\r", 1, true) or raw:find("\0", 1, true) then
      return nil, chunkname .. ":" .. line .. ": CR/NUL is not allowed"
    end
    if raw ~= "" then
      local fields = {}
      local start = 1
      while true do
        local tab = raw:find("\t", start, true)
        if tab == nil then
          fields[#fields + 1] = raw:sub(start)
          break
        end
        fields[#fields + 1] = raw:sub(start, tab - 1)
        start = tab + 1
      end
      if expected ~= nil and #fields ~= expected then
        return nil, chunkname .. ":" .. line .. ": expected " .. expected .. " fields, found " .. #fields
      end
      rows[#rows + 1] = fields
    end
  end
  return rows
end

return M
