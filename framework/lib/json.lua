local M = {}

local ESCAPES = {
  ['"'] = '\\"',
  ["\\"] = "\\\\",
  ["\b"] = "\\b",
  ["\f"] = "\\f",
  ["\n"] = "\\n",
  ["\r"] = "\\r",
  ["\t"] = "\\t",
}

local function escape(s)
  return '"'
    .. s:gsub('[%c\\"]', function(c)
      return ESCAPES[c] or string.format("\\u%04x", string.byte(c))
    end)
    .. '"'
end

local function array_length(t)
  local n = 0
  for k in pairs(t) do
    if type(k) ~= "number" or k < 1 or k % 1 ~= 0 then
      return nil
    end
    n = n + 1
  end
  for i = 1, n do
    if t[i] == nil then
      return nil
    end
  end
  return n
end

local function encode(v, out)
  local tv = type(v)
  if v == nil then
    out[#out + 1] = "null"
  elseif tv == "boolean" then
    out[#out + 1] = v and "true" or "false"
  elseif tv == "number" then
    if v ~= v or v == math.huge or v == -math.huge then
      error("cannot encode non-finite number", 3)
    end
    out[#out + 1] = string.format("%.17g", v)
  elseif tv == "string" then
    out[#out + 1] = escape(v)
  elseif tv == "table" then
    local n = array_length(v)
    if n ~= nil then
      out[#out + 1] = "["
      for i = 1, n do
        if i > 1 then
          out[#out + 1] = ","
        end
        encode(v[i], out)
      end
      out[#out + 1] = "]"
    else
      local keys = {}
      for k in pairs(v) do
        if type(k) ~= "string" then
          error("object keys must be strings", 3)
        end
        keys[#keys + 1] = k
      end
      table.sort(keys)
      out[#out + 1] = "{"
      for i = 1, #keys do
        if i > 1 then
          out[#out + 1] = ","
        end
        out[#out + 1] = escape(keys[i])
        out[#out + 1] = ":"
        encode(v[keys[i]], out)
      end
      out[#out + 1] = "}"
    end
  else
    error("cannot encode type " .. tv, 3)
  end
end

---@param value table|string|number|boolean|nil
---@return string
function M.encode(value)
  local out = {}
  encode(value, out)
  return table.concat(out)
end

return M
