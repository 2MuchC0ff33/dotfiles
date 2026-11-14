-- luacheck: globals package
local h = require("tests.lib.harness")

package.path = "../lib/planmode/?.lua;" .. package.path
local profile = require("profile")

local template_path = "../templates/repo/AGENTS.block.txt"
local gates_fixture = "tests/fixtures/planmode/gates"
local work_file = "work/AGENTS.md"

local function read(path)
  local f = assert(io.open(path, "rb"))
  local data = f:read("*a")
  f:close()
  return data
end

local function write(path, data)
  local f = assert(io.open(path, "wb"))
  f:write(data)
  f:close()
end

local function exists(path)
  local f = io.open(path, "rb")
  if not f then
    return false
  end
  f:close()
  return true
end

local function count(text, needle)
  local n = 0
  local pos = 1
  while true do
    local s = text:find(needle, pos, true)
    if not s then
      return n
    end
    n = n + 1
    pos = s + #needle
  end
end

local function reset()
  os.remove(work_file)
end

h.describe("profile detect", function()
  h.it("detects gates from a Makefile", function()
    local info = profile.detect(gates_fixture)
    h.eq(info.repo_name, "gates")
    h.eq(info.gates, "make verify")
    h.eq(info.exceptions, "none")
  end)

  h.it("preserves an existing Exceptions value", function()
    reset()
    write(work_file, "# rules\n\nExceptions: Gate exception: no man page\n")
    local info = profile.detect("work")
    h.eq(info.vcs, "none")
    h.eq(info.exceptions, "Gate exception: no man page")
    reset()
  end)

  if exists("../CVS/Root") then
    h.it("detects the enclosing CVS checkout", function()
      local info = profile.detect("..")
      h.eq(info.vcs, "cvs")
      h.ok(info.cvs_root ~= "none")
      h.eq(info.gates, "make verify")
    end)
  elseif exists("../.git/config") then
    h.it("detects the enclosing Git checkout", function()
      local info = profile.detect("..")
      h.eq(info.vcs, "git")
      h.ok(info.git_remote ~= "none")
      h.eq(info.gates, "make verify")
    end)
  end
end)

h.describe("profile render", function()
  h.it("replaces every placeholder", function()
    local info = {
      repo_name = "elvis",
      vcs = "git",
      cvs_root = "none",
      cvs_module = "none",
      git_remote = "git@example.com:elvis.git",
      gates = "make lua-check | make c-gate",
      exceptions = "Toolchain exception: pinned",
    }
    local block = profile.render(info, read(template_path))
    for _, token in ipairs({ "@REPO@", "@VCS@", "@CVS_ROOT@", "@CVS_MODULE@", "@GIT_REMOTE@", "@GATES@" }) do
      h.ok(not block:find(token, 1, true))
    end
    h.ok(block:find("Repo-Name: elvis", 1, true))
    h.ok(block:find("VCS: git", 1, true))
    h.ok(block:find("Git-Remote: git@example.com:elvis.git", 1, true))
    h.ok(block:find("Plan-Root: ~/.opencode/plan/elvis/", 1, true))
    h.ok(block:find("Gates: make lua-check | make c-gate", 1, true))
    h.ok(block:find("Exceptions: Toolchain exception: pinned", 1, true))
    h.eq(count(block, "<!-- canonical-workflow:begin -->"), 1)
    h.eq(count(block, "<!-- canonical-workflow:end -->"), 1)
  end)
end)

h.describe("profile apply", function()
  h.it("adds a block when AGENTS.md is absent", function()
    reset()
    local block = profile.render(profile.detect("work"), read(template_path))
    h.eq(profile.apply("work", block), "added")
    local data = read(work_file)
    h.eq(count(data, "<!-- canonical-workflow:begin -->"), 1)
    h.eq(count(data, "<!-- canonical-workflow:end -->"), 1)
  end)

  h.it("appends after existing text and keeps it intact", function()
    reset()
    write(work_file, "# Project rules\n\nKeep me.\n")
    local block = profile.render(profile.detect("work"), read(template_path))
    h.eq(profile.apply("work", block), "added")
    local data = read(work_file)
    h.ok(data:find("# Project rules\n\nKeep me.\n\n<!-- canonical-workflow:begin -->", 1, true))
  end)

  h.it("is idempotent on a second apply", function()
    reset()
    local block = profile.render(profile.detect("work"), read(template_path))
    profile.apply("work", block)
    local first = read(work_file)
    h.eq(profile.apply("work", block), "updated")
    local second = read(work_file)
    h.eq(first, second)
    h.eq(count(second, "<!-- canonical-workflow:begin -->"), 1)
    h.eq(count(second, "<!-- canonical-workflow:end -->"), 1)
  end)

  h.it("preserves a manual Gates and Exceptions value", function()
    reset()
    local block = profile.render(profile.detect("work"), read(template_path))
    profile.apply("work", block)
    local data = read(work_file)
    data = data:gsub("Gates: none", "Gates: make custom", 1)
    data = data:gsub("Exceptions: none", "Exceptions: Gate exception: custom", 1)
    write(work_file, data)
    profile.apply("work", block)
    local after = read(work_file)
    h.ok(after:find("Gates: make custom", 1, true))
    h.ok(after:find("Exceptions: Gate exception: custom", 1, true))
    h.eq(count(after, "<!-- canonical-workflow:begin -->"), 1)
  end)

  h.it("never rewrites text outside the markers", function()
    reset()
    local block = profile.render(profile.detect("work"), read(template_path))
    profile.apply("work", block)
    local data = read(work_file)
    local tail = "\n## Trailing rules\n\nKeep this too.\n"
    write(work_file, data .. tail)
    profile.apply("work", block)
    local after = read(work_file)
    h.ok(after:find("## Trailing rules\n\nKeep this too.\n", 1, true))
  end)

  h.it("errors when only one marker exists", function()
    reset()
    write(work_file, "# rules\n\n<!-- canonical-workflow:begin -->\n")
    local block = profile.render(profile.detect("work"), read(template_path))
    h.fails(function()
      profile.apply("work", block)
    end, "expected a single-marker error")
  end)
end)

reset()
