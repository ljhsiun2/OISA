/*************************************************************
 *
 *  Note: this bitonic sort algorithm only works when
 *  N(number of elements to sort) is a power of 2
 *
 *************************************************************/

#include <assert.h>
#include <stdio.h>
#include "sort.h"

static inline void oswap(int *a, int *b, int if_swap){
    __asm__ __volatile__ (  "movl (%0), %%eax\n\t"
                            "movl (%1), %%ebx\n\t"
                            "movl %%eax, %%ecx\n\t"
                            "cmpl $0, %2\n\t"
                            "cmovnel %%ebx, %%eax\n\t"
                            "cmovnel %%ecx, %%ebx\n\t"
                            "movl %%eax, (%0)\n\t"
                            "movl %%ebx, (%1)"
                            :
                            : "r"(a), "r"(b), "rm"(if_swap)
                            : "%eax", "%ebx", "%ecx", "cc", "memory"
                        );
}

static void checkPowerOfTwo(int val) {
    while (val % 2 == 0)
        val = val >> 1;
    if (val != 1){
        fprintf(stderr, "ERROR: bitonic sort only works for array with length of power of two!\n");
        assert(val == 1);
    }
}

static void CompAndSwap(int arr[], int i, int j, int dir, int block_sz){
    int act_dir = (arr[i*block_sz] > arr[j*block_sz]);
    for (int k = 0; k < block_sz; k++)
        oswap(&arr[i*block_sz]+k, &arr[j*block_sz]+k, (dir == act_dir));
}

static void BitonicMerge(int arr[], int low, int cnt, int dir, int block_sz){
    if (cnt > 1){
        int k = cnt / 2;
        for (int i=low; i<low + k; i++)
            CompAndSwap(arr, i, i+k, dir, block_sz);
        BitonicMerge(arr, low, k, dir, block_sz);
        BitonicMerge(arr, low+k, k, dir, block_sz);
    }
}

static void BitonicSubSort(int arr[], int low, int cnt, int dir, int block_sz){
    if (cnt > 1){
        int k = cnt / 2;
        BitonicSubSort(arr, low, k, 1, block_sz);
        BitonicSubSort(arr, low+k, k, 0, block_sz);
        BitonicMerge(arr, low, cnt, dir, block_sz);
    }
}

// dir = 1 is ascending order
//     = 0 is descending order
void BitonicSort_i(int arr[], int N, int dir){
    checkPowerOfTwo(N);
    BitonicSubSort(arr, 0, N, dir, 1);
}

void BitonicSort_T(int arr[], int num_blocks, int dir, int block_sz){
    checkPowerOfTwo(num_blocks);
    BitonicSubSort(arr, 0, num_blocks, dir, block_sz);
}

