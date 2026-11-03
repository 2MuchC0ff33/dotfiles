local kv = require("lib.kv")

local M = {}

local DEFAULTS = {
  APP_NAME = "framework",
  DB_PATH = "srv/framework.db",
  WORK_DIR = "work",
  SPOOL_DIR = "spool",
  SRV_DIR = "srv",
  BUILD_DIR = "build",
  LUA_BIN = "lua5.4",
  LUAC_BIN = "luac5.4",
}

---@param path string
---@return table<string, string>|nil
---@return string|nil
function M.load_config(path)
  local f, err = io.open(path, "r")
  if f == nil then
    return nil, err
  end
  local text = f:read("*a")
  f:close()
  local parsed, perr = kv.parse(text, path)
  if parsed == nil then
    return nil, perr
  end
  local out = {}
  for k, v in pairs(DEFAULTS) do
    out[k] = v
  end
  for k, v in pairs(parsed) do
    out[k] = v
  end
  for _, k in ipairs({ "DB_PATH", "WORK_DIR", "SPOOL_DIR", "SRV_DIR", "BUILD_DIR" }) do
    if out[k] == nil or out[k] == "" then
      return nil, "missing " .. k
    end
  end
  return out
end

---@param cfg table<string, string>
---@param name string
---@param key string
---@return table<string, string>
function M.env_override(cfg, name, key)
  local v = os.getenv(name)
  if v ~= nil and v ~= "" then
    cfg[key] = v
  end
  return cfg
end

return M
