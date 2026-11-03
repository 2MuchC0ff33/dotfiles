local M = {}

local function fail(s, msg)
  error({
    literal = true,
    message = string.format("%s:%d:%d: %s", s.chunk, s.line, s.col, msg),
  }, 0)
end

local function peek(s)
  return s.text:sub(s.pos, s.pos)
end

local function advance(s)
  local c = s.text:sub(s.pos, s.pos)
  s.pos = s.pos + 1
  if c == "\n" then
    s.line = s.line + 1
    s.col = 1
  else
    s.col = s.col + 1
  end
  return c
end

local function skip(s)
  while true do
    local c = peek(s)
    if c == "" then
      return
    end
    if c == " " or c == "\t" or c == "\r" or c == "\n" then
      advance(s)
    elseif c == "-" and s.text:sub(s.pos, s.pos + 1) == "--" then
      while peek(s) ~= "" and peek(s) ~= "\n" do
        advance(s)
      end
    else
      return
    end
  end
end

local function read_name(s)
  local start = s.pos
  while peek(s):match("[A-Za-z0-9_]") do
    advance(s)
  end
  return s.text:sub(start, s.pos - 1)
end

local function read_number(s)
  local start = s.pos
  if peek(s) == "-" then
    advance(s)
  end
  local digits = 0
  while peek(s):match("[0-9]") do
    advance(s)
    digits = digits + 1
  end
  if digits == 0 then
    fail(s, "expected integer")
  end
  local n = tonumber(s.text:sub(start, s.pos - 1))
  if n == nil or n % 1 ~= 0 then
    fail(s, "expected integer")
  end
  return n
end

local ESCAPES = {
  ["\\"] = "\\",
  ['"'] = '"',
  n = "\n",
  t = "\t",
  r = "\r",
}

local function read_string(s)
  if advance(s) ~= '"' then
    fail(s, "expected string")
  end
  local out = {}
  while true do
    local c = peek(s)
    if c == "" then
      fail(s, "unterminated string")
    end
    if c == '"' then
      advance(s)
      return table.concat(out)
    end
    if c == "\n" then
      fail(s, "newline in string")
    end
    if c == "\\" then
      advance(s)
      local e = advance(s)
      local v = ESCAPES[e]
      if v == nil then
        fail(s, "invalid escape \\" .. e)
      end
      out[#out + 1] = v
    else
      out[#out + 1] = advance(s)
    end
  end
end

local parse_value

local function parse_table(s, depth)
  if depth > 64 then
    fail(s, "nesting too deep")
  end
  if advance(s) ~= "{" then
    fail(s, "expected {")
  end
  local out = {}
  local index = 1
  skip(s)
  if peek(s) == "}" then
    advance(s)
    return out
  end
  while true do
    skip(s)
    if peek(s) == "[" then
      advance(s)
      local key = parse_value(s, depth + 1)
      if type(key) ~= "string" and type(key) ~= "number" then
        fail(s, "table key must be string or integer")
      end
      ---@cast key string|number
      skip(s)
      if advance(s) ~= "]" then
        fail(s, "expected ]")
      end
      skip(s)
      if advance(s) ~= "=" then
        fail(s, "expected =")
      end
      local value = parse_value(s, depth + 1)
      if out[key] ~= nil then
        fail(s, "duplicate key")
      end
      out[key] = value
    else
      local assigned = false
      local save_pos, save_line, save_col = s.pos, s.line, s.col
      if peek(s):match("[A-Za-z_]") then
        local name = read_name(s)
        skip(s)
        if peek(s) == "=" then
          advance(s)
          local value = parse_value(s, depth + 1)
          if out[name] ~= nil then
            fail(s, "duplicate key " .. name)
          end
          out[name] = value
          assigned = true
        else
          s.pos, s.line, s.col = save_pos, save_line, save_col
        end
      end
      if not assigned then
        local value = parse_value(s, depth + 1)
        if out[index] ~= nil then
          fail(s, "duplicate array index " .. index)
        end
        out[index] = value
        index = index + 1
      end
    end
    skip(s)
    local c = peek(s)
    if c == "," or c == ";" then
      advance(s)
      skip(s)
      if peek(s) == "}" then
        advance(s)
        return out
      end
    elseif c == "}" then
      advance(s)
      return out
    else
      fail(s, "expected , or }")
    end
  end
end

parse_value = function(s, depth)
  skip(s)
  local c = peek(s)
  if c == "{" then
    return parse_table(s, depth)
  end
  if c == '"' then
    return read_string(s)
  end
  if c == "-" or c:match("[0-9]") then
    return read_number(s)
  end
  if c:match("[A-Za-z_]") then
    local name = read_name(s)
    if name == "true" then
      return true
    end
    if name == "false" then
      return false
    end
    if name == "nil" then
      fail(s, "nil is not allowed")
    end
    fail(s, "unexpected name " .. name)
  end
  fail(s, "unexpected character " .. (c == "" and "<eof>" or c))
end

---@param text string
---@param chunkname string|nil
---@return table|nil
---@return string|nil
function M.parse(text, chunkname)
  if type(text) ~= "string" then
    error("text must be a string", 2)
  end
  if #text > 1048576 then
    return nil, "input exceeds 1 MiB"
  end
  local s = {
    text = text,
    pos = 1,
    line = 1,
    col = 1,
    chunk = chunkname or "<literal>",
  }
  local ok, result = pcall(function()
    skip(s)
    local word = read_name(s)
    if word ~= "return" then
      fail(s, "expected return")
    end
    local value = parse_value(s, 0)
    skip(s)
    if peek(s) ~= "" then
      fail(s, "trailing input")
    end
    return value
  end)
  if ok then
    ---@cast result table
    return result, nil
  end
  if type(result) == "table" and result.literal then
    return nil, result.message
  end
  return nil, tostring(result)
end

return M
