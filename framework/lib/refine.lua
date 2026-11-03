local M = {}

local function is_string(v)
  return type(v) == "string" and v ~= ""
end

local function is_array(v)
  if type(v) ~= "table" then
    return false
  end
  local n = 0
  for k in pairs(v) do
    if type(k) ~= "number" or k < 1 or k % 1 ~= 0 then
      return false
    end
    n = n + 1
  end
  for i = 1, n do
    if v[i] == nil then
      return false
    end
  end
  return true
end

local function exists(path)
  local f = io.open(path, "r")
  if f == nil then
    return false
  end
  f:close()
  return true
end

---@param proof table
---@param root string|nil
---@return boolean|nil
---@return string|nil
function M.validate(proof, root)
  if type(proof) ~= "table" then
    return nil, "proof must be a table"
  end
  if not is_string(proof.refinement) then
    return nil, "refinement must be a non-empty string"
  end
  local spec = proof.spec
  if type(spec) ~= "table" then
    return nil, "spec must be a table"
  end
  for _, k in ipairs({
    "input",
    "output",
    "precondition",
    "postcondition",
    "failure",
    "safety",
    "determinism",
    "resource_bound",
    "liveness",
  }) do
    if spec[k] == nil then
      return nil, "spec." .. k .. " is required"
    end
  end
  if type(spec.determinism) ~= "boolean" then
    return nil, "spec.determinism must be boolean"
  end
  for _, k in ipairs({ "precondition", "postcondition", "failure", "safety" }) do
    if not is_array(spec[k]) then
      return nil, "spec." .. k .. " must be an array"
    end
  end
  local impl = proof.implementation
  if type(impl) ~= "table" then
    return nil, "implementation must be a table"
  end
  if not is_string(impl.language) then
    return nil, "implementation.language is required"
  end
  if not is_string(impl.entrypoint) then
    return nil, "implementation.entrypoint is required"
  end
  if root ~= nil and not exists(root .. "/" .. impl.entrypoint) then
    return nil, "implementation.entrypoint not found: " .. impl.entrypoint
  end
  if not is_array(proof.checks) or #proof.checks == 0 then
    return nil, "checks must be a non-empty array"
  end
  for i, p in ipairs(proof.checks) do
    if not is_string(p) then
      return nil, "checks[" .. i .. "] must be a string"
    end
    if root ~= nil and not exists(root .. "/" .. p) then
      return nil, "check not found: " .. p
    end
  end
  return true
end

return M
