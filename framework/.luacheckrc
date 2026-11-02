std = "none"
max_line_length = 120
max_comment_line_length = 120
self = false
unused_args = false

globals = {
  "assert", "error", "getmetatable", "ipairs", "next", "pairs", "pcall",
  "print", "rawequal", "rawget", "rawlen", "rawset", "require", "select",
  "setmetatable", "tonumber", "tostring", "type", "warn", "xpcall",
  "io", "os", "string", "table", "math", "utf8", "coroutine",
}

files["tests/run.lua"] = {
  globals = { "arg", "dofile", "loadfile" },
}

files["tests/proofs.lua"] = {
  globals = { "arg" },
}

files["tests/unit/*.lua"] = {
  globals = { "arg" },
}
