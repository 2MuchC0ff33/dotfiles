local util = require("util")

local M = {}

local BEGIN_MARKER = "<!-- canonical-workflow:begin -->"
local END_MARKER = "<!-- canonical-workflow:end -->"
local NONE = "none"

local function trim(text)
  return (text:gsub("^%s+", ""):gsub("%s+$", ""))
end

local function read_optional(path)
  local file = io.open(path, "rb")
  if not file then
    return nil
  end
  local data = file:read("*a")
  file:close()
  return data
end

local function split_lines(text)
  local lines = {}
  local pos = 1
  while pos <= #text do
    local nl = text:find("\n", pos, true)
    if nl then
      lines[#lines + 1] = text:sub(pos, nl - 1)
      pos = nl + 1
    else
      lines[#lines + 1] = text:sub(pos)
      pos = #text + 1
    end
  end
  return lines
end

local function first_line(path)
  local data = read_optional(path)
  if not data then
    return nil
  end
  local line = data:match("^([^\n]*)")
  line = trim(line)
  if line == "" then
    return nil
  end
  return line
end

local function basename(path)
  local clean = path:gsub("/+$", "")
  if clean == "" then
    clean = path
  end
  local name = clean:match("([^/]+)$")
  return name or clean
end

local function field_value(text, key)
  if not text then
    return nil
  end
  for _, line in ipairs(split_lines(text)) do
    local value = line:match("^" .. key .. ":%s*(.-)%s*$")
    if value then
      return value
    end
  end
  return nil
end

local function set_field(text, key, value)
  local replaced = false
  local lines = split_lines(text)
  for i, line in ipairs(lines) do
    if not replaced and line:match("^" .. key .. ":%s*") then
      lines[i] = key .. ": " .. value
      replaced = true
    end
  end
  if not replaced then
    lines[#lines + 1] = key .. ": " .. value
  end
  local out = table.concat(lines, "\n")
  if text:sub(-1) == "\n" then
    out = out .. "\n"
  end
  return out
end

local function git_remote(git_config)
  local data = read_optional(git_config)
  if not data then
    return NONE
  end
  local in_origin = false
  for _, line in ipairs(split_lines(data)) do
    local section = line:match("^%s*%[([^%]]+)%]")
    if section then
      in_origin = (section == 'remote "origin"')
    elseif in_origin then
      local url = line:match("^%s*url%s*=%s*(.-)%s*$")
      if url and url ~= "" then
        return url
      end
    end
  end
  return NONE
end

local function detect_gates(repo)
  local makefile = read_optional(repo .. "/Makefile")
  if not makefile then
    return NONE
  end
  for _, line in ipairs(split_lines(makefile)) do
    if line:match("^verify:") then
      return "make verify"
    end
  end
  return NONE
end

function M.detect(repo)
  repo = repo or "."
  local info = {
    repo_name = basename(repo),
    vcs = NONE,
    cvs_root = NONE,
    cvs_module = NONE,
    git_remote = NONE,
    gates = NONE,
    exceptions = NONE,
  }

  if read_optional(repo .. "/CVS/Root") then
    info.vcs = "cvs"
    info.cvs_root = first_line(repo .. "/CVS/Root") or NONE
    info.cvs_module = first_line(repo .. "/CVS/Repository") or NONE
  elseif read_optional(repo .. "/.git/config") or read_optional(repo .. "/.git/HEAD") then
    info.vcs = "git"
    info.git_remote = git_remote(repo .. "/.git/config")
  end

  info.gates = detect_gates(repo)

  local existing = field_value(read_optional(repo .. "/AGENTS.md"), "Exceptions")
  if existing and existing ~= "" then
    info.exceptions = existing
  end
  return info
end

function M.render(info, template)
  local values = {
    REPO = info.repo_name,
    VCS = info.vcs,
    CVS_ROOT = info.cvs_root,
    CVS_MODULE = info.cvs_module,
    GIT_REMOTE = info.git_remote,
    GATES = info.gates,
  }
  local out = template
  for key, value in pairs(values) do
    if value == nil or value == "" then
      value = NONE
    end
    out = out:gsub("@" .. key .. "@", function()
      return value
    end)
  end
  out = set_field(out, "Exceptions", info.exceptions or NONE)
  return out
end

local function preserve_field(block, existing, key)
  local value = field_value(existing, key)
  if value and value ~= "" then
    return set_field(block, key, value)
  end
  return block
end

function M.apply(repo, block)
  repo = repo or "."
  local path = repo .. "/AGENTS.md"
  local data = read_optional(path)

  if not data then
    util.write_all(path, block)
    return "added"
  end

  local begin_start = data:find(BEGIN_MARKER, 1, true)
  local end_start, end_end = data:find(END_MARKER, 1, true)
  if (begin_start and not end_start) or (end_start and not begin_start) then
    error(path .. " has only one canonical-workflow marker")
  end

  if not begin_start then
    local out = data
    if out ~= "" and out:sub(-1) ~= "\n" then
      out = out .. "\n"
    end
    if out ~= "" then
      out = out .. "\n"
    end
    util.write_all(path, out .. block)
    return "added"
  end

  if end_end < begin_start then
    error(path .. " has canonical-workflow markers in the wrong order")
  end
  if data:find(BEGIN_MARKER, end_end + 1, true) then
    error(path .. " has more than one canonical-workflow block")
  end

  local existing = data:sub(begin_start, end_end)
  local new_block = preserve_field(block, existing, "Gates")
  new_block = preserve_field(new_block, existing, "Exceptions")

  local tail = data:sub(end_end + 1)
  if new_block:sub(-1) == "\n" and tail:sub(1, 1) == "\n" then
    tail = tail:sub(2)
  end
  local out = data:sub(1, begin_start - 1) .. new_block .. tail
  util.write_all(path, out)
  return "updated"
end

return M
