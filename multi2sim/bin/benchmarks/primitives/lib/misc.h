#ifndef __MISC_HEADER__
#define __MISC_HEADER__

#include <stdint.h>

// calculate the log_2 value _after_ round val up to the closest power_of_2 value
// Example: log_2(1024) = 10, log_2(1025) = 11
unsigned int log_2(unsigned int val);

unsigned int bitwiseReverse(unsigned int val, int L);

int roundToPowerOf2(int val);

#endif
