#ifndef __ASM_HEADER__
#define __ASM_HEADER__

#include <stdint.h>

inline uint64_t rdtsc(void){
    uint32_t hi, lo;
    __asm__ __volatile__ (  "rdtsc"
                            : "=a"(lo), "=d"(hi)
            );
    return ( (uint64_t)lo | (((uint64_t)hi) << 32) );
}

inline void cmov(int cond, int* src_ptr, int* dst_ptr){
    __asm__ __volatile__ (  "movl (%2), %%eax\n\t"
                            "testl %0, %0\n\t"
                            "cmovnel (%1), %%eax\n\t"
                            "movl %%eax, (%2)"
                            :
                            : "b" (cond), "c" (src_ptr), "d" (dst_ptr)
                            : "cc", "%eax", "memory"
            );
}

inline void cmovn(int cond, int* src_ptr, int* dst_ptr, int sz){
    for(int i = 0; i < sz; i++)
        cmov(cond, src_ptr+i, dst_ptr+i);
}

#endif
