#include "sort.h"
#include <stdio.h>
#include <stdlib.h>

/*#define MERGE_SORT*/

typedef struct {
    int key1;
    int key2;
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
    printf(" @@@ Test Block Sort @@@\n");
    int N = 8;
    Ent* entries = (Ent*) malloc(sizeof(Ent) * N);

    for (int i = 0; i < N; i++) {
        entries[i].key1 = rand() % 10;
        entries[i].key2 = rand() % 10;
        entries[i].data_a = rand() % 100;
        entries[i].data_b = rand() % 100;
    }

    for (int i = 0; i < N; i++) {
        printf("entry #%d is: key1 = %d, key2 = %d, data_a = %d, data_b = %d\n", i, entries[i].key1, entries[i].key2, entries[i].data_a, entries[i].data_b);
    }

#ifdef MERGE_SORT 
    MergeSort_Block((int*)entries, N, 1, 1, sizeof(Ent) / sizeof(int));
#else
    BitonicSort_Block((int*)entries, N, 1, 1, sizeof(Ent) / sizeof(int));
#endif
    printf("\n Sort done.\n");

    for (int i = 0; i < N; i++) {
        printf("entry #%d is: key1 = %d, key2 = %d, data_a = %d, data_b = %d\n", i, entries[i].key1, entries[i].key2, entries[i].data_a, entries[i].data_b);
    }
    free(entries);

    /***************************************/
    printf("\n @@@ Test Assco Sort @@@\n");
    N = 8;
    entries = (Ent*) malloc(sizeof(Ent) * N);
    int data_sz = 2;
    int* data = (int*) malloc(sizeof(int) * N * data_sz);
    for (int i = 0; i < N; i++) {
        entries[i].key1 = rand() % 10;
        entries[i].key2 = rand() % 10;
        entries[i].data_a = rand() % 100;
        entries[i].data_b = rand() % 100;
        for (int j = 0; j < data_sz; j++) {
            data[i * data_sz + j] = rand() % 100;
        }
    }
    for (int i = 0; i < N; i++) {
        printf("entry #%d is: key1 = %d, key2 = %d, data_a = %d, data_b = %d | ", i, entries[i].key1, entries[i].key2, entries[i].data_a, entries[i].data_b);
        for(int j = 0; j < data_sz; j++)
            printf("data[%d] = %d  ", j, data[i*data_sz + j]);
        printf("\n");
    }
#ifdef MERGE_SORT
    MergeSort_TwoArray((int*)entries, (int*)data, N, 1, 1, sizeof(Ent)/sizeof(int), data_sz);
#else
    BitonicSort_TwoArray((int*)entries, (int*)data, N, 1, 1, sizeof(Ent)/sizeof(int), data_sz);
#endif
    printf("\n Sort done.\n");

    for (int i = 0; i < N; i++) {
        printf("entry #%d is: key1 = %d, key2 = %d, data_a = %d, data_b = %d | ", i, entries[i].key1, entries[i].key2, entries[i].data_a, entries[i].data_b);
        for(int j = 0; j < data_sz; j++)
            printf("data[%d] = %d  ", j, data[i*data_sz + j]);
        printf("\n");
    }
    free(entries);
    free(data);

    /**********************************/
    printf("\n@@@ Test General Sort @@@\n");

    N = 16;
    MultKeyEnt* multkey_entries = (MultKeyEnt*) malloc(sizeof(MultKeyEnt) * N);

    for (int i = 0; i < N; i++){
        multkey_entries[i].key1 = rand() % 10;
        multkey_entries[i].key2 = rand() % 10;
        multkey_entries[i].key3 = rand() % 10;
        multkey_entries[i].data = i;
    }

    for (int i = 0; i < N; i++) {
        printf("entries #%d is: key1 = %d, key2 = %d, key3 = %d, data = %d\n", i, multkey_entries[i].key1, multkey_entries[i].key2, multkey_entries[i].key3, multkey_entries[i].data);
    }

#ifdef MERGE_SORT
    MergeSort_General((int*) multkey_entries, N, sizeof(MultKeyEnt) / sizeof(int), 2, 1, 0, 1);
#else
    BitonicSort_General((int*) multkey_entries, N, sizeof(MultKeyEnt) / sizeof(int), 0, 1, 1, 1);
#endif
    printf("\n Sort done.\n");

    for (int i = 0; i < N; i++) {
        printf("entries #%d is: key1 = %d, key2 = %d, key3 = %d, data = %d\n", i, multkey_entries[i].key1, multkey_entries[i].key2, multkey_entries[i].key3, multkey_entries[i].data);
    }
    free(multkey_entries);

    printf("\n@@@ Test Two Array Two key Sort @@@\n");
    multkey_entries = (MultKeyEnt*) malloc(sizeof(MultKeyEnt) * N);
    data = (int*) malloc(sizeof(int) * N * data_sz);

    for (int i = 0; i < N; i++){
        multkey_entries[i].key1 = rand() % 10;
        multkey_entries[i].key2 = rand() % 10;
        multkey_entries[i].key3 = rand() % 10;
        multkey_entries[i].data = i;
        for (int j = 0; j < data_sz; j++) {
            data[i * data_sz + j] = rand() % 100;
        }
    }

    for (int i = 0; i < N; i++) {
        printf("entries #%d is: key1 = %d, key2 = %d, key3 = %d, data = %d | ", i, multkey_entries[i].key1, multkey_entries[i].key2, multkey_entries[i].key3, multkey_entries[i].data);
        for (int j = 0; j < data_sz; j++)
            printf("data[%d] = %d  ", j, data[i*data_sz + j]);
        printf("\n");
    }
    
#ifdef MERGE_SORT
    MergeSort_TwoArray_TwoKey((int*)entries, (int*) data, N, 2, 1, 1, 0, sizeof(MultKeyEnt)/sizeof(int), data_sz);
#else
    BitonicSort_TwoArray_TwoKey((int*)entries, (int*) data, N, 2, 1, 1, 0, sizeof(MultKeyEnt)/sizeof(int), data_sz);
#endif
    printf("\n Sort done.\n");

    for (int i = 0; i < N; i++) {
        printf("entries #%d is: key1 = %d, key2 = %d, key3 = %d, data = %d | ", i, multkey_entries[i].key1, multkey_entries[i].key2, multkey_entries[i].key3, multkey_entries[i].data);
        for (int j = 0; j < data_sz; j++)
            printf("data[%d] = %d  ", j, data[i*data_sz + j]);
        printf("\n");
    }
    free(multkey_entries);
    free(data);
}
