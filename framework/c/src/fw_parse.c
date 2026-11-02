#include "fw_parse.h"

#include <limits.h>

int fw_parse_i64(const char *s, long long *out)
{
  const char *p;
  unsigned long long acc;
  unsigned long long limit;
  int negative;

  if (s == (const char *)0 || out == (long long *)0) {
    return -1;
  }

  p = s;
  negative = 0;
  if (*p == '-') {
    negative = 1;
    p++;
  }
  if (*p == '\0') {
    return -1;
  }

  limit = (unsigned long long)LLONG_MAX;
  if (negative) {
    limit = limit + 1ULL;
  }

  acc = 0ULL;
  while (*p != '\0') {
    unsigned int digit;

    if (*p < '0' || *p > '9') {
      return -1;
    }
    digit = (unsigned int)(*p - '0');
    if (acc > (limit - (unsigned long long)digit) / 10ULL) {
      return -1;
    }
    acc = acc * 10ULL + (unsigned long long)digit;
    p++;
  }

  if (negative) {
    if (acc == (unsigned long long)LLONG_MAX + 1ULL) {
      *out = LLONG_MIN;
    } else {
      *out = -(long long)acc;
    }
  } else {
    *out = (long long)acc;
  }
  return 0;
}
