#include "asm.h"

extern inline uint64_t rdtsc(void);

extern inline void cmov(int cond, int* src_ptr, int* dst_ptr);

extern inline void cmovn(int cond, int* src_ptr, int* dst_ptr, int sz);
