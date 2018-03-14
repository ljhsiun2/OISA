#include "sort.h"
#include <stdio.h>
#include <stdlib.h>

typedef struct {
    int key;
    int data_a;
    int data_b;
} Ent;

typedef struct {
    int key1;
    int key2;
    int key3;
    int data;
} MultKeyEnt;

int main(){
    /*printf(" @@@ Test Block Sort @@@\n");*/
    /*int N = 8;*/
    /*Ent* entries = (Ent*) malloc(sizeof(Ent) * N);*/

    /*for (int i = 0; i < N; i++) {*/
        /*entries[i].key = N - i;*/
        /*entries[i].data_a = rand() % 100;*/
        /*entries[i].data_b = rand() % 100;*/
    /*}*/

    /*for (int i = 0; i < N; i++) {*/
        /*printf("entry #%d is: key = %d, data_a = %d, data_b = %d\n", i, entries[i].key, entries[i].data_a, entries[i].data_b);*/
    /*}*/

    /*[>BitonicSort_Block((int*)entries, N, 1, sizeof(Ent) / sizeof(int));<]*/
    /*MergeSort_Block((int*)entries, N, 1, sizeof(Ent) / sizeof(int));*/
    /*printf("\n Sort done.\n");*/

    /*for (int i = 0; i < N; i++) {*/
        /*printf("entry #%d is: key = %d, data_a = %d, data_b = %d\n", i, entries[i].key, entries[i].data_a, entries[i].data_b);*/
    /*}*/

    /*printf("\n @@@ Test Assco Sort @@@\n");*/
    /*int data_sz = 2;*/
    /*int* data = (int*) malloc(sizeof(int) * N * data_sz);*/
    /*for (int i = 0; i < N; i++) {*/
        /*entries[i].key = N - i;*/
        /*entries[i].data_a = rand() % 100;*/
        /*entries[i].data_b = rand() % 100;*/
        /*for (int j = 0; j < data_sz; j++) {*/
            /*data[i * data_sz + j] = rand() % 100;*/
        /*}*/
    /*}*/
    /*for (int i = 0; i < N; i++) {*/
        /*printf("entry #%d is: key = %d, data_a = %d, data_b = %d\n", i, entries[i].key, entries[i].data_a, entries[i].data_b);*/
        /*for(int j = 0; j < data_sz; j++)*/
            /*printf("                    data[%d] = %d\n", j, data[i*data_sz + j]);*/
    /*}*/

    /*[>BitonicSort_TwoArray((int*)entries, (int*)data, N, 1, sizeof(Ent)/sizeof(int), data_sz);<]*/
    /*MergeSort_TwoArray((int*)entries, (int*)data, N, 1, sizeof(Ent)/sizeof(int), data_sz);*/
    /*printf("\n Sort done.\n");*/

    /*for (int i = 0; i < N; i++) {*/
        /*printf("entry #%d is: key = %d, data_a = %d, data_b = %d\n", i, entries[i].key, entries[i].data_a, entries[i].data_b);*/
        /*for(int j = 0; j < data_sz; j++)*/
            /*printf("                    data[%d] = %d\n", j, data[i*data_sz + j]);*/
    /*}*/

    int N = 16;
    MultKeyEnt* entries = (MultKeyEnt*) malloc(sizeof(MultKeyEnt) * N);

    for (int i = 0; i < N; i++){
        entries[i].key1 = rand() % 10;
        entries[i].key2 = rand() % 10;
        entries[i].key3 = rand() % 10;
        entries[i].data = i;
    }

    printf("@@@ Before sorting:\n");
    for (int i = 0; i < N; i++) {
        printf("entries #%d is: key1 = %d, key2 = %d, key3 = %d, data = %d\n", i, entries[i].key1, entries[i].key2, entries[i].key3, entries[i].data);
    }

    /*MergeSort_General((int*) entries, N, sizeof(MultKeyEnt) / sizeof(int), 2, 1, 0, 1);*/
    BitonicSort_General((int*) entries, N, sizeof(MultKeyEnt) / sizeof(int), 0, 1, 1, 1);

    printf("@@@ After sorting:\n");
    for (int i = 0; i < N; i++) {
        printf("entries #%d is: key1 = %d, key2 = %d, key3 = %d, data = %d\n", i, entries[i].key1, entries[i].key2, entries[i].key3, entries[i].data);
    }

    free(entries);
}
