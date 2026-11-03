local M = {}

local REQUIRED = {
  "stage_id",
  "purpose",
  "inputs",
  "outputs",
  "tool_or_language",
  "determinism",
  "failure_modes",
  "validation",
  "proof_reference",
}

---@param stage table
---@return boolean|nil
---@return string|nil
function M.validate(stage)
  if type(stage) ~= "table" then
    return nil, "stage must be a table"
  end
  for _, k in ipairs(REQUIRED) do
    if stage[k] == nil then
      return nil, "missing " .. k
    end
  end
  if type(stage.stage_id) ~= "string" or stage.stage_id == "" then
    return nil, "stage_id must be a non-empty string"
  end
  if type(stage.determinism) ~= "boolean" then
    return nil, "determinism must be boolean"
  end
  for _, k in ipairs({ "inputs", "outputs", "failure_modes", "validation" }) do
    if type(stage[k]) ~= "table" or #stage[k] == 0 then
      return nil, k .. " must be a non-empty array"
    end
  end
  if type(stage.proof_reference) ~= "string" then
    return nil, "proof_reference must be a string"
  end
  return true
end

return M
