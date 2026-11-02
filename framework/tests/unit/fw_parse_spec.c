#include <assert.h>
#include <limits.h>
#include <stdio.h>

#include "fw_parse.h"

int main(void)
{
  long long v = 0;

  assert(fw_parse_i64("0", &v) == 0 && v == 0);
  assert(fw_parse_i64("-42", &v) == 0 && v == -42);
  assert(fw_parse_i64("9223372036854775807", &v) == 0 && v == LLONG_MAX);
  assert(fw_parse_i64("-9223372036854775808", &v) == 0 && v == LLONG_MIN);
  assert(fw_parse_i64("", &v) != 0);
  assert(fw_parse_i64("12x", &v) != 0);
  assert(fw_parse_i64("--1", &v) != 0);
  assert(fw_parse_i64(" 1", &v) != 0);
  assert(fw_parse_i64("9223372036854775808", &v) != 0);
  assert(fw_parse_i64((const char *)0, &v) != 0);
  assert(fw_parse_i64("1", (long long *)0) != 0);

  puts("fw_parse_spec: ok");
  return 0;
}
