-- luacheck: globals package
local h = require("tests.lib.harness")

package.path = "../lib/planmode/?.lua;" .. package.path
local resolve = require("resolve")

local plan_root = "tests/fixtures/planmode/plan"
local repo_root = "tests/fixtures/planmode/repo"
local repo_name = "dotfiles"

local function plan_file(id)
  return plan_root .. "/" .. repo_name .. "/" .. id .. "/HANDOVER.md"
end

local function plan_dir(id)
  return plan_root .. "/" .. repo_name .. "/" .. id
end

h.describe("resolve identity", function()
  h.it("parses keys and keeps the first occurrence", function()
    local identity = resolve.parse_identity("Repo: a\nStatus: READY\nRepo: b\n")
    h.eq(identity.Repo, "a")
    h.eq(identity.Status, "READY")
  end)

  h.it("accepts safe segments and rejects unsafe ones", function()
    h.eq(resolve.valid_segment("2026-01-01-alpha"), true)
    h.eq(resolve.valid_segment("."), false)
    h.eq(resolve.valid_segment(".."), false)
    h.eq(resolve.valid_segment("a/b"), false)
    h.eq(resolve.valid_segment("foo*"), false)
    h.eq(resolve.valid_segment(""), false)
  end)
end)

h.describe("resolve selection", function()
  h.it("selects an explicit plan", function()
    local got, code = resolve.select(repo_root, repo_name, "2026-01-01-alpha", {}, plan_root)
    h.eq(code, 0)
    h.eq(got, plan_dir("2026-01-01-alpha"))
  end)

  h.it("selects an explicit repo-qualified plan", function()
    local got, code = resolve.select(repo_root, repo_name, repo_name .. "/2026-01-01-beta", {}, plan_root)
    h.eq(code, 0)
    h.eq(got, plan_dir("2026-01-01-beta"))
  end)

  h.it("reports a missing explicit plan", function()
    local got, code, msg = resolve.select(repo_root, repo_name, "2026-01-01-missing", {}, plan_root)
    h.eq(got, nil)
    h.eq(code, 2)
    h.ok(msg:find("dotfiles", 1, true))
    h.ok(msg:find(plan_dir("2026-01-01-missing"), 1, true))
  end)

  h.it("rejects a plan for another repository", function()
    local got, code = resolve.select(repo_root, repo_name, "elvis/2026-01-01-x", {}, plan_root)
    h.eq(got, nil)
    h.eq(code, 3)
  end)

  h.it("rejects unsafe arguments", function()
    for _, arg in ipairs({ "../dotfiles/2026-01-01-x", "a/b/c", "/abs", "foo*" }) do
      local got, code = resolve.select(repo_root, repo_name, arg, {}, plan_root)
      h.eq(got, nil)
      h.eq(code, 5)
    end
  end)

  h.it("rejects an invalid identity block", function()
    local _, code = resolve.select(repo_root, repo_name, "2026-01-01-bad", {}, plan_root)
    h.eq(code, 4)

    local _, code2 = resolve.select(repo_root, repo_name, "2026-01-01-wrongdir", {}, plan_root)
    h.eq(code2, 4)
  end)

  h.it("rejects a blocked handover", function()
    local _, code = resolve.select(repo_root, repo_name, "2026-01-01-blocked", {}, plan_root)
    h.eq(code, 4)
  end)
end)

h.describe("resolve bare selection", function()
  h.it("selects a sole READY candidate", function()
    local got, code = resolve.select(repo_root, repo_name, nil, { plan_file("2026-01-01-alpha") }, plan_root)
    h.eq(code, 0)
    h.eq(got, plan_dir("2026-01-01-alpha"))
  end)

  h.it("ignores blocked and foreign candidates", function()
    local got, code = resolve.select(repo_root, repo_name, "", {
      plan_file("2026-01-01-blocked"),
      plan_root .. "/elvis/2026-01-01-x/HANDOVER.md",
      plan_file("2026-01-01-alpha"),
    }, plan_root)
    h.eq(code, 0)
    h.eq(got, plan_dir("2026-01-01-alpha"))
  end)

  h.it("rejects two READY candidates", function()
    local got, code, msg = resolve.select(repo_root, repo_name, "", {
      plan_file("2026-01-01-alpha"),
      plan_file("2026-01-01-beta"),
    }, plan_root)
    h.eq(got, nil)
    h.eq(code, 2)
    h.ok(msg:find(plan_dir("2026-01-01-alpha"), 1, true))
    h.ok(msg:find(plan_dir("2026-01-01-beta"), 1, true))
  end)

  h.it("rejects zero candidates", function()
    local got, code = resolve.select(repo_root, repo_name, "", {}, plan_root)
    h.eq(got, nil)
    h.eq(code, 2)
  end)

  h.it("skips the unexpanded shell glob", function()
    local got, code = resolve.select(repo_root, repo_name, "", {
      plan_root .. "/" .. repo_name .. "/*/HANDOVER.md",
      plan_file("2026-01-01-alpha"),
    }, plan_root)
    h.eq(code, 0)
    h.eq(got, plan_dir("2026-01-01-alpha"))
  end)
end)
