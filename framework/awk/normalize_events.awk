BEGIN {
  FS = "\t"
  OFS = "\t"
  status = 0
}

{
  if (NF != 7) {
    printf "normalize_events: INPUT_INVALID: %s line %d: expected 7 fields, found %d\n", FILENAME, NR, NF > "/dev/stderr"
    status = 3
    exit status
  }
  if ($3 !~ /^-?[0-9]+$/) {
    printf "normalize_events: INPUT_INVALID: %s line %d: expected integer timestamp, found %s\n", FILENAME, NR, $3 > "/dev/stderr"
    status = 3
    exit status
  }
  print $1, $2, $3, $4, $5, $6, $7
}

END {
  if (status != 0) {
    exit status
  }
}
