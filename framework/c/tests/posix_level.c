#include <unistd.h>

#if _POSIX_VERSION != 200809L
#error "POSIX.1-2017 (200809L) required"
#endif

int main(void)
{
  return 0;
}
