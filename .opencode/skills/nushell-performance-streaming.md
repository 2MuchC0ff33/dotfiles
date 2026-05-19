# Streaming for Large Files

## Description
`lines` + pipeline for line-by-line processing of large files. FORBIDDEN: Loading entire large files into memory when streaming suffices.

## When to Load
Load this skill when processing large files that may exceed available memory.

## Source
STANDARDS.adoc §11.5.10 (lines 4392–4410)

## Key Rules

- MANDATE: Use `lines` + pipeline for line-by-line processing of large files
- FORBIDDEN: Loading entire large files into memory when streaming suffices
- SHOULD: `first N` / `take while` to limit processing early

## Rationale

Loading a multi-GB file entirely into memory is wasteful and can crash the process. The `lines` command streams file content line-by-line through the pipeline, keeping memory usage proportional to the largest line rather than the entire file.

## Example

```nu
# BAD — loads entire file into memory
let data = (open huge-file.log)      # reads everything into RAM!
$data | lines | where $it =~ 'error'

# GOOD — streaming line-by-line
open huge-file.log | lines | where $it =~ 'error'

# BAD — entire file processing
let json = (open large-data.json)    # huge memory spike
$json | each {|item| process $item }

# GOOD — streaming if possible (for NDJSON/JSONL)
open large-data.jsonl | lines | each {|line|
    $line | from json | process
}

# BAD — read whole file for early data
let data = (open big-file.txt)
$data | lines | first 10

# GOOD — stream and stop early
open big-file.txt | lines | first 10

# BAD — loading whole file just to count lines
let line_count = (open huge.log | lines | length)   # streams fine actually

# GOOD — streaming count
open huge.log | lines | length                      # memory-efficient

# GOOD — limit early with take while
open access.log | lines | take while {|line|
    not ($line =~ 'END MARKER')
} | where $it =~ 'ERROR'
```
