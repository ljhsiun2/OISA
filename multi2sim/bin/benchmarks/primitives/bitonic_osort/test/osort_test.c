/*************************************************************
 *
 *  Note: this bitonic sort algorithm only works when
 *  N(number of elements to sort) is a power of 2
 *
 *************************************************************/

#include <time.h>
#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>


static inline uint64_t getticks(){
    uint32_t a, b;
    __asm__ __volatile__ (  "rdtsc"
                            : "=a"(a), "=d"(b)
                        );
    return ( ((uint64_t)a) | (((uint64_t)b) << 32) );
}

static inline void swap(int* a, int *b, int dir, int act_dir){
    if (dir == act_dir){
        int temp = *a;
        *a = *b;
        *b = temp;
    }
}

static inline void oswap(int *a, int *b, int dir, int act_dir){
    __asm__ __volatile__ (  "cmpl  %2, %3\n\t"
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

void CompAndSwap(int a[], int i, int j, int dir, int obliv){
    /*if (dir == (a[i] > a[j]))*/
        /*swap(&a[i], &a[j]);*/
    int act_dir = (a[i] > a[j]);
    if (obliv)
        oswap(&a[i], &a[j], dir, act_dir);
    else
        swap(&a[i], &a[j], dir, act_dir);
}

void BitonicMerge(int a[], int low, int cnt, int dir, int obliv){
    if (cnt > 1){
        int k = cnt / 2;
        for (int i=low; i<low + k; i++)
            CompAndSwap(a, i, i+k, dir, obliv);
        BitonicMerge(a, low, k, dir, obliv);
        BitonicMerge(a, low+k, k, dir, obliv);
    }
}

void BitonicSort(int a[], int low, int cnt, int dir, int obliv){
    if (cnt > 1){
        int k = cnt / 2;
        BitonicSort(a, low, k, 1, obliv);
        BitonicSort(a, low+k, k, 0, obliv);
        BitonicMerge(a, low, cnt, dir, obliv);
    }
}

void Sort(int a[], int N, int dir, int obliv){
    BitonicSort(a, 0, N, dir, obliv);
}

int main(){
    uint64_t tick1, tick2, tick3;
    int exponent = (rand() % 15) + 10;
    int N = 2 << exponent;
    int* a = (int*)malloc(sizeof(int) * N);
    int* b = (int*)malloc(sizeof(int) * N);

    srand(time(NULL));
    for(int i=0; i<N; i++){
        int r = rand() / 10000000;
        a[i] = r;
        b[i] = r;
    }

    /*printf("original array a: ");*/
    /*for (int i=0; i<N-1; i++)*/
        /*printf("%d,", a[i]);*/
    /*printf("%d\n", a[N-1]);*/
    /*printf("original array b: ");*/
    /*for (int i=0; i<N-1; i++)*/
        /*printf("%d,", b[i]);*/
    /*printf("%d\n", b[N-1]);*/

    int dir = 1; // in ascending order

    tick1 = getticks();
    Sort(a, N, dir, 1);
    tick2 = getticks();
    Sort(b, N, dir, 0);
    tick3 = getticks();

    uint64_t obliv_time = tick2 - tick1;
    uint64_t nonobliv_time = tick3 - tick2;
    double speedup = (double)nonobliv_time / obliv_time;

    printf("sizeof array = 2^%d = %d\n", exponent, N);
    printf("Oblivious sort takes  %" PRIu64 "\n", obliv_time);
    printf("baseline takes %" PRIu64"\n", nonobliv_time);
    printf("speedup = %f\n", speedup);
    /*printf("sorted array a: ");*/
    /*for (int i=0; i<N-1; i++)*/
        /*printf("%d,", a[i]);*/
    /*printf("%d\n", a[N-1]);*/
    /*printf("sorted array b: ");*/
    /*for (int i=0; i<N-1; i++)*/
        /*printf("%d,", b[i]);*/
    /*printf("%d\n", b[N-1]);*/

    return 0;
}
