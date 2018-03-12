/*************************************************************
 *
 *  Note: this bitonic sort algorithm only works when
 *  N(number of elements to sort) is a power of 2
 *
 *************************************************************/

#include <math.h>
#include <time.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

#define ASCENDING   1
#define DESCENDING  0

static inline uint64_t rdtsc(void){
    uint32_t high, low;
    __asm__ __volatile__ (  "rdtsc\n\t"
                            : "=a" (low), "=d"(high)
                        );
    return ((uint64_t) low) | (((uint64_t)high) << 32) ;
}

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



void CompAndSwap(int a[], int i, int j, int dir){
    int act_dir = (a[i] > a[j]);
    oswap(&a[i], &a[j], (dir == act_dir));
}

void BitonicMerge(int a[], int low, int cnt, int dir){
    if (cnt > 1){
        int k = cnt / 2;
        for (int i=low; i<low + k; i++)
            CompAndSwap(a, i, i+k, dir);
        BitonicMerge(a, low, k, dir);
        BitonicMerge(a, low+k, k, dir);
    }
}

void BitonicSort(int a[], int low, int cnt, int dir){
    if (cnt > 1){
        int k = cnt / 2;
        BitonicSort(a, low, k, 1);
        BitonicSort(a, low+k, k, 0);
        BitonicMerge(a, low, cnt, dir);
    }
}

// dir = 1 is ascending order
//     = 0 is descending order
void Sort(int a[], int N, int dir){
    BitonicSort(a, 0, N, dir);
}


int main(int argc, char** argv){

    /*time_t t1 = clock();*/

    int exp = atoi(argv[1]);
    int order = atoi(argv[2]);
    int seed = atoi(argv[3]);
    int N = 1 << exp;
    int* a = (int*)malloc(sizeof(int) * N);
    /*printf("generate %d random numbers as an array\n", N);*/

    /*srand(seed);*/
    for(int i=0; i<N; i++){
        a[i] = i;//rand() % (3 * N); // + (i ^ exp);
    }

    /*time_t t2 = clock();*/

    Sort(a, N, order);

    /*time_t sort_time = clock() - t2;*/
    /*int msec = sort_time * 1000 / CLOCKS_PER_SEC;*/
    /*printf("sort time: %d ms\n", msec);*/

    /*for (int i = 0; i < N; i++)*/
        /*printf("a[%d] = %d\n", i, a[i]);*/
    printf("a[1] = %d\n", a[1]);

    /*time_t main_time = clock() - t1;*/
    /*msec = main_time * 1000 / CLOCKS_PER_SEC;*/
    /*printf("main time: %d\n", msec);*/



    return 0;
}
