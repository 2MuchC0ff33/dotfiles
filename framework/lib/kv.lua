local M = {}

---@param text string
---@param chunkname string|nil
---@return table<string, string>|nil
---@return string|nil
function M.parse(text, chunkname)
  chunkname = chunkname or "<kv>"
  local out = {}
  local line = 0
  for raw in (text .. "\n"):gmatch("(.-)\n") do
    line = line + 1
    if raw:find("\r", 1, true) then
      return nil, chunkname .. ":" .. line .. ": CR is not allowed"
    end
    if raw:find("\0", 1, true) then
      return nil, chunkname .. ":" .. line .. ": NUL is not allowed"
    end
    if utf8.len(raw) == nil then
      return nil, chunkname .. ":" .. line .. ": invalid UTF-8"
    end
    local s = raw:match("^%s*(.-)%s*$")
    if s ~= "" and s:sub(1, 1) ~= "#" then
      local k, v = s:match("^([A-Za-z_][A-Za-z0-9_]*)=(.*)$")
      if k == nil then
        return nil, chunkname .. ":" .. line .. ": expected KEY=VALUE"
      end
      if out[k] ~= nil then
        return nil, chunkname .. ":" .. line .. ": duplicate key " .. k
      end
      out[k] = v
    end
  end
  return out
end

return M
