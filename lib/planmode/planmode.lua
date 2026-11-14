local util = require("util")
local config = require("config")
local ascii = require("ascii")
local verify = require("verify")
local mirror = require("mirror")

local errors = 0
local function fail(msg)
  errors = errors + 1
  io.stderr:write("error: " .. msg .. "\n")
end
local function ok(msg) io.write("ok: " .. msg .. "\n") end
local function read_stdin() return io.stdin:read("*a") end

local REFERENCES = {
  ["README.md"] = "README.txt",
  ["framework/README.md"] = "framework/README.txt",
  ["framework/docs/architecture.md"] = "framework/docs/architecture.txt",
  ["framework/docs/conformance.md"] = "framework/docs/conformance.txt",
  ["framework/docs/decisions.md"] = "framework/docs/decisions.txt",
  ["framework/docs/plugins.md"] = "framework/docs/plugins.txt",
  ["framework/docs/skills.md"] = "framework/docs/skills.txt",
  ["framework/docs/adr/0001-posix-2017-only.md"] = "framework/docs/adr/0001-posix-2017-only.txt",
  ["framework/docs/adr/0002-lua-54-runtime.md"] = "framework/docs/adr/0002-lua-54-runtime.txt",
  ["framework/docs/adr/0003-cksum-integrity.md"] = "framework/docs/adr/0003-cksum-integrity.txt",
  ["framework/docs/adr/0004-zero-extension-core.md"] = "framework/docs/adr/0004-zero-extension-core.txt",
  ["framework/docs/adr/0005-c99-tcc.md"] = "framework/docs/adr/0005-c99-tcc.txt",
  ["framework/docs/adr/0006-proofs-as-data.md"] = "framework/docs/adr/0006-proofs-as-data.txt",
  ["framework/docs/adr/0007-dual-man-gates.md"] = "framework/docs/adr/0007-dual-man-gates.txt",
  ["framework/docs/adr/0008-plugins-opt-in.md"] = "framework/docs/adr/0008-plugins-opt-in.txt",
  ["framework/plugins/websocket/README.md"] = "framework/plugins/websocket/README.txt",
  ["skills/README.md"] = "skills/README.txt",
}

local function cmd_config_add(src, dst)
  local out = config.add_subagent_depth(util.read_all(src))
  util.write_all(dst, out)
end

local function cmd_config_remove(src, dst)
  local out = config.remove_subagent_depth(util.read_all(src))
  util.write_all(dst, out)
end

local function cmd_normalize(path)
  local data = util.read_all(path)
  local out = ascii.normalize(data)
  local index = select(1, ascii.first_non_ascii(out))
  if index then error(path .. " retains non-ascii byte at " .. index) end
  if out ~= data then util.write_all(path, out) end
end

local function cmd_ref_update(path)
  local data = util.read_all(path)
  if not (util.is_ascii(data)) then
    local index = select(1, ascii.first_non_ascii(data))
    error(path .. " is binary or non-ascii at byte " .. tostring(index))
  end
  local out = data
  for old, new in pairs(REFERENCES) do
    out = out:gsub(old:gsub("-", "%%-"):gsub("%.", "%%."), new)
  end
  if out ~= data then util.write_all(path, out) end
end

local function cmd_mirror_plan(src_list, dst_list) mirror.plan(src_list, dst_list) end
local function cmd_mirror_copy(list_file, src_root, dst_root) mirror.copy_manifest(list_file, src_root, dst_root) end
local function cmd_ascii_check(list_file)
  for line in io.lines(list_file) do
    local f = io.open(line, "rb")
    if f then
      local data = f:read("*a")
      f:close()
      local index, byte = ascii.first_non_ascii(data)
      if index then fail(line .. " non-ascii byte " .. tostring(byte) .. " at " .. index) end
    end
  end
  if errors > 0 then os.exit(1) end
  ok("ascii gate passed")
end

local function cmd_verify_agents()
  verify.plan_agent(read_stdin(), function(msg) fail(msg) end)
  if errors > 0 then os.exit(1) end
  ok("agents verified")
end

local function cmd_verify_root(root)
  verify.required_files(root or ".", function(msg) fail(msg) end)
  if errors > 0 then os.exit(1) end
  ok("root files verified")
end

local function cmd_verify_protocol(path)
  verify.protocol(util.read_all(path), function(msg) fail(msg) end)
  if errors > 0 then os.exit(1) end
  ok("protocol verified")
end

local function cmd_resolve_plan(a)
  local resolve = require("resolve")
  local candidates = {}
  for i = 4, #a do candidates[#candidates + 1] = a[i] end
  local dir, code, message = resolve.select(a[1], a[2], a[3], candidates)
  if code ~= 0 then
    if message then io.stderr:write(message .. "\n") end
    os.exit(code)
  end
  io.write(dir .. "\n")
end

local function cmd_repo_profile(a)
  local profile = require("profile")
  local root = a[1]
  local mode = "emit"
  local repo = root
  local i = 2
  while i <= #a do
    if a[i] == "--emit" then
      mode = "emit"
    elseif a[i] == "--apply" then
      mode = "apply"
    elseif a[i] == "--repo" then
      i = i + 1
      if i > #a then error("--repo requires a directory") end
      repo = a[i]
    else
      error("unknown option: " .. tostring(a[i]))
    end
    i = i + 1
  end
  local info = profile.detect(repo)
  local template = util.read_all(root .. "/templates/repo/AGENTS.block.txt")
  local block = profile.render(info, template)
  if mode == "emit" then
    io.write(block)
    if block:sub(-1) ~= "\n" then io.write("\n") end
  else
    ok(profile.apply(repo, block))
  end
end

local function cmd_verify_generic(root)
  verify.generic(root or ".", function(msg) fail(msg) end)
  if errors > 0 then os.exit(1) end
  ok("generic workflow verified")
end

local commands = {
  ["config-add"] = function(a) cmd_config_add(a[1], a[2]) end,
  ["config-remove"] = function(a) cmd_config_remove(a[1], a[2]) end,
  ["normalize"] = function(a) cmd_normalize(a[1]) end,
  ["ref-update"] = function(a) cmd_ref_update(a[1]) end,
  ["ascii-check"] = function(a) cmd_ascii_check(a[1]) end,
  ["mirror-plan"] = function(a) cmd_mirror_plan(a[1], a[2]) end,
  ["mirror-copy"] = function(a) cmd_mirror_copy(a[1], a[2], a[3]) end,
  ["verify-agents"] = function() cmd_verify_agents() end,
  ["verify-root"] = function(a) cmd_verify_root(a[1]) end,
  ["verify-protocol"] = function(a) cmd_verify_protocol(a[1]) end,
  ["resolve-plan"] = function(a) cmd_resolve_plan(a) end,
  ["repo-profile"] = function(a) cmd_repo_profile(a) end,
  ["verify-generic"] = function(a) cmd_verify_generic(a[1]) end,
}

local command = arg[1]
local handler = commands[command]
if not handler then io.stderr:write("usage: planmode-luac <command> ...\n"); os.exit(2) end
local rest = {}
for i = 2, #arg do rest[#rest + 1] = arg[i] end
local ok_call, err = pcall(handler, rest)
if not ok_call then io.stderr:write("error: " .. tostring(err) .. "\n"); os.exit(1) end
