#include <stdio.h>

#if __STDC_VERSION__ != 199901L
#error "C99 (199901L) required"
#endif

int main(void)
{
  printf("%ld\n", (long)__STDC_VERSION__);
  return 0;
}
