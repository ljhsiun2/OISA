/*************************************************************
 *
 *  Note: this bitonic sort algorithm only works when
 *  N(number of elements to sort) is a power of 2
 *
 *************************************************************/

#include <assert.h>
#include <stdio.h>
#include "sort.h"

static int key1_idx;
static int key2_idx;

static int block_sz = -1;
static int block_sz_main = -1;
static int block_sz_aux  = -1;

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

/// Function: Compare two elements. IF the order is opposite to dir, swap two elements.
static void CompAndSwap_Int(int arr[], int i, int j, int dir){
    int act_dir = (arr[i] > arr[j]);
    int if_swap = (dir == act_dir);
    oswap(&arr[i], &arr[j], if_swap);
}
static void CompAndSwap_Block(int arr[], int i, int j, int dir){
    int act_dir = (arr[i*block_sz] > arr[j*block_sz]);
    int if_swap = (dir == act_dir);
    for (int k = 0; k < block_sz; k++)
        oswap(&arr[i*block_sz]+k, &arr[j*block_sz]+k, if_swap);
}
static void CompAndSwap_General(int arr[], int i, int j, int dir1, int dir2){
    int act_dir1 = (arr[i*block_sz+key1_idx] > arr[j*block_sz+key1_idx]);
    int dir1_eq = (arr[i*block_sz+key1_idx] == arr[j*block_sz+key1_idx]);
    int act_dir2 = (arr[i*block_sz+key2_idx] > arr[j*block_sz+key2_idx]);
    int if_swap = ((!dir1_eq) && (act_dir1 == dir1)) || ((dir1_eq) && (act_dir2 == dir2));
    for (int k = 0; k < block_sz; k++)
        oswap(&arr[i*block_sz]+k, &arr[j*block_sz]+k, if_swap);
}
static void CompAndSwap_TwoArray(int arr_main[], int arr_aux[], int i, int j, int dir){
    int act_dir = (arr_main[i*block_sz_main] > arr_main[j*block_sz_main]);
    int if_swap = (dir == act_dir);
    for (int k = 0; k < block_sz_main; k++)
        oswap(&arr_main[i*block_sz_main]+k, &arr_main[j*block_sz_main]+k, if_swap);
    for (int k = 0; k < block_sz_aux; k++)
        oswap(&arr_aux[i*block_sz_aux]+k, &arr_aux[j*block_sz_aux]+k, if_swap);
}


/// Function: Subroutine: merge
static void BitonicMerge_Int(int arr[], int low, int cnt, int dir){
    // TODO: improve by adding base case cnt = 4/8 and using vector operation
    if (cnt > 1){
        int k = cnt / 2;
        for (int i=low; i<low + k; i++)
            CompAndSwap_Int(arr, i, i+k, dir);
        BitonicMerge_Int(arr, low, k, dir);
        BitonicMerge_Int(arr, low+k, k, dir);
    }
}
static void BitonicMerge_Block(int arr[], int low, int cnt, int dir){
    if (cnt > 1){
        int k = cnt / 2;
        for (int i=low; i<low + k; i++)
            CompAndSwap_Block(arr, i, i+k, dir);
        BitonicMerge_Block(arr, low, k, dir);
        BitonicMerge_Block(arr, low+k, k, dir);
    }
}
static void BitonicMerge_General(int arr[], int low, int cnt, int dir1, int dir2){
    if (cnt > 1){
        int k = cnt / 2;
        for (int i=low; i<low + k; i++)
            CompAndSwap_General(arr, i, i+k, dir1, dir2);
        BitonicMerge_General(arr, low, k, dir1, dir2);
        BitonicMerge_General(arr, low+k, k, dir1, dir2);
    }
}
static void BitonicMerge_TwoArray(int arr_main[], int arr_aux[], int low, int cnt, int dir){
    if (cnt > 1){
        int k = cnt / 2;
        for (int i=low; i<low + k; i++)
            CompAndSwap_TwoArray(arr_main, arr_aux, i, i+k, dir);
        BitonicMerge_TwoArray(arr_main, arr_aux, low, k, dir);
        BitonicMerge_TwoArray(arr_main, arr_aux, low+k, k, dir);
    }
}


/// Function: Subroutine: sort
static void BitonicSubSort_Int(int arr[], int low, int cnt, int dir){
    if (cnt > 1){
        int k = cnt / 2;
        BitonicSubSort_Int(arr, low, k, 1);
        BitonicSubSort_Int(arr, low+k, k, 0);
        BitonicMerge_Int(arr, low, cnt, dir);
    }
}
static void BitonicSubSort_Block(int arr[], int low, int cnt, int dir){
    if (cnt > 1){
        int k = cnt / 2;
        BitonicSubSort_Block(arr, low, k, 1);
        BitonicSubSort_Block(arr, low+k, k, 0);
        BitonicMerge_Block(arr, low, cnt, dir);
    }
}
static void BitonicSubSort_General(int arr[], int low, int cnt, int dir1, int dir2){
    if (cnt > 1){
        int k = cnt / 2;
        BitonicSubSort_General(arr, low, k, 1, 1);
        BitonicSubSort_General(arr, low+k, k, 0, 0);
        BitonicMerge_General(arr, low, cnt, dir1, dir2);
    }
}
static void BitonicSubSort_TwoArray(int arr_main[], int arr_aux[], int low, int cnt, int dir){
    if (cnt > 1){
        int k = cnt / 2;
        BitonicSubSort_TwoArray(arr_main, arr_aux, low, k, 1);
        BitonicSubSort_TwoArray(arr_main, arr_aux, low+k, k, 0);
        BitonicMerge_TwoArray(arr_main, arr_aux, low, cnt, dir);
    }
}


/// Callable functions. Currently three versions
//  dir = 1 is ascending order
//     = 0 is descending order
void BitonicSort_Int(int arr[], int N, int dir){
    checkPowerOfTwo(N);
    BitonicSubSort_Int(arr, 0, N, dir);
}

void BitonicSort_Block(int arr[], int N, int dir, int _block_sz){
    block_sz = _block_sz;
    checkPowerOfTwo(N);
    BitonicSubSort_Block(arr, 0, N, dir);
}

void BitonicSort_General(int arr[], int N, int _block_sz, int _key1_idx, int dir1, int _key2_idx, int dir2){
    key1_idx = _key1_idx;
    key2_idx = _key2_idx;
    block_sz = _block_sz;
    checkPowerOfTwo(N);
    BitonicSubSort_General(arr, 0, N, dir1, dir2);
}

void BitonicSort_TwoArray(int arr_main[], int arr_aux[], int N, int dir, int _block_sz_main, int _block_sz_aux){
    block_sz_main = _block_sz_main;
    block_sz_aux  = _block_sz_aux;
    checkPowerOfTwo(N);
    BitonicSubSort_TwoArray(arr_main, arr_aux, 0, N, dir);
}

