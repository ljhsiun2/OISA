#ifndef __ASM_HEADER__
#define __ASM_HEADER__

#include <stdint.h>

uint64_t rdtsc(void);

unsigned int log_2(unsigned int val);

unsigned int bitwiseReverse(unsigned int val, int L);

int roundToPowerOf2(int val);

#endif
