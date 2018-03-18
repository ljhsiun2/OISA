#include "misc.h"

unsigned int log_2(unsigned int val){
    val = (val << 1) - 1;
    unsigned int result = 0;
    while (val>>=1)
        result ++;

    return result;
}

unsigned int bitwiseReverse(unsigned int val, int L){
    unsigned int result = 0;
    for (int i = 0; i < L; i++){
        result = (result << 1) + val % 2;
        val = val / 2;
   }
    return result;
}

int roundToPowerOf2(int val){
    int expt = 1;
    while (val>>=1)
        expt++;
    return (1 << expt);
}
