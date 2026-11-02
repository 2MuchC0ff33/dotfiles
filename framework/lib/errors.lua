local M = {}

local EXIT = {
  INPUT_INVALID = 3,
  ENV_MISSING = 4,
  TOOL_CONTRACT = 3,
  TRANSFORM_FAILED = 1,
  STATE_CONFLICT = 1,
  PROOF_FAILED = 5,
  EDGE_FAILED = 1,
  PROGRAMMER_ERROR = 1,
}

---@param class string
---@return integer
function M.exit_code(class)
  local code = EXIT[class]
  if code == nil then
    error("unknown error class: " .. tostring(class), 2)
  end
  return code
end

---@param class string
---@param stage string
---@param artifact string|nil
---@param expected string
---@param observed string
---@param hint string|nil
---@return string
function M.format(class, stage, artifact, expected, observed, hint)
  local parts = { stage, class }
  if artifact ~= nil then
    parts[#parts + 1] = artifact
  end
  parts[#parts + 1] = "expected " .. expected
  parts[#parts + 1] = "observed " .. observed
  local msg = table.concat(parts, ": ")
  if hint ~= nil then
    msg = msg .. "; hint: " .. hint
  end
  return msg
end

return M
