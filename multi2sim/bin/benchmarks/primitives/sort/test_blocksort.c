#include "sort.h"
#include <stdio.h>
#include <stdlib.h>

typedef struct {
    int key;
    int data_a;
    int data_b;
} Ent;

int main(){
    int N = 8;
    Ent* entries = (Ent*) malloc(sizeof(Ent) * N);

    for (int i = 0; i < N; i++) {
        entries[i].key = N - i;
        entries[i].data_a = rand() % 100;
        entries[i].data_b = rand() % 100;
    }

    for (int i = 0; i < N; i++) {
        printf("entry #%d is: key = %d, data_a = %d, data_b = %d\n", i, entries[i].key, entries[i].data_a, entries[i].data_b);
    }

    BitonicSort_T((int*)entries, N, 1, sizeof(Ent) / sizeof(int));
    printf("\n Sort done.\n");

    for (int i = 0; i < N; i++) {
        printf("entry #%d is: key = %d, data_a = %d, data_b = %d\n", i, entries[i].key, entries[i].data_a, entries[i].data_b);
    }
}
