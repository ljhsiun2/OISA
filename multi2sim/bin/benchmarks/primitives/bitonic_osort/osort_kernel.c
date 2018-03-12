/*************************************************************
 *
 *  Note: this bitonic sort algorithm only works when
 *  N(number of elements to sort) is a power of 2
 *
 *************************************************************/

#include <time.h>
#include <stdio.h>
#include <stdlib.h>

static inline void oswap(int *a, int *b, int dir, int act_dir){
    __asm__ __volatile__ (  "cmpl %2, %3\n\t"
                            "movl (%0), %%eax\n\t"
                            "movl (%1), %%ebx\n\t"
                            "movl %%eax, %%ecx\n\t"
                            "cmovel %%ebx, %%eax\n\t"
                            "cmovel %%ecx, %%ebx\n\t"
                            "movl %%eax, (%0)\n\t"
                            "movl %%ebx, (%1)"
                            : "+r"(a), "+r"(b)
                            : "a"(dir), "b"(act_dir)
                            : "%ecx", "cc", "memory"
                        );
}

void CompAndSwap(int a[], int i, int j, int dir){
    int act_dir = (a[i] > a[j]);
    oswap(&a[i], &a[j], dir, act_dir);
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

void Sort(int a[], int N, int dir){
    BitonicSort(a, 0, N, dir);
}

int main(){

    int N = 1024;
    int* a = (int*)malloc(sizeof(int) * N);

    for(int i=0; i<N; i++){
        int r = rand() / 10000000;
        a[i] = r;
    }

    Sort(a, N, 1);

    return 0;
}
