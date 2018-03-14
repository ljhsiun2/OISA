#include <stdlib.h>
#include <stdio.h>
#include "sort.h"

static int* buf_L;
static int* buf_R;
static int* buf_L_aux;
static int* buf_R_aux;

static int dir;
static int dir1;
static int dir2;

static int key1_idx;
static int key2_idx;

static int block_sz = -1;
static int block_sz_main = -1;
static int block_sz_aux  = -1;

static void Merge_Int(int arr[], int l, int m, int r){
    int i, j, k;
    int len_L = m - l + 1;
    int len_R = r - m;
    
    for(i = 0; i < len_L; i++)
       buf_L[i] = arr[l + i];
    for(j = 0; j < len_R; j++)
       buf_R[j] = arr[m + 1 + j];

    i = 0;
    j = 0;
    k = l;
    
    while (i < len_L && j < len_R){
        if ( (buf_L[i] <= buf_R[j] && dir == ASCENDING) || (buf_L[i] >= buf_R[j] && dir == DESCENDING) ) {
            arr[k] = buf_L[i];
            i++;
        } else {
            arr[k] = buf_R[j];
            j++;
        }
        k++;
    } 
    while (i < len_L){
        arr[k] = buf_L[i];
        i++;
        k++;
    }
    while (j < len_R){
        arr[k] = buf_R[j];
        j++;
        k++;
    }
}

static void Merge_Block(int arr[], int l, int m, int r){
    int h, i, j, k;
    int len_L = m - l + 1;
    int len_R = r - m;
    
    for(i = 0; i < len_L; i++)
        for(h = 0; h < block_sz; h++)
            buf_L[i*block_sz + h] = arr[(l + i)*block_sz + h];
    for(j = 0; j < len_R; j++)
        for(h = 0; h < block_sz; h++)
            buf_R[j*block_sz + h] = arr[(m + 1 + j) * block_sz + h];

    i = 0;
    j = 0;
    k = l;
    
    while (i < len_L && j < len_R){
        if ( (buf_L[i*block_sz] <= buf_R[j*block_sz] && dir == ASCENDING) || (buf_L[i*block_sz] >= buf_R[j*block_sz] && dir == DESCENDING) ) {
            for(h = 0; h < block_sz; h++)
                arr[k*block_sz + h] = buf_L[i*block_sz + h];
            i++;
        } else {
            for(h = 0; h < block_sz; h++)
                arr[k*block_sz + h] = buf_R[j*block_sz + h];
            j++;
        }
        k++;
    } 
    while (i < len_L){
        for(h = 0; h < block_sz; h++)
            arr[k*block_sz + h] = buf_L[i*block_sz + h];
        i++;
        k++;
    }
    while (j < len_R){
        for(h = 0; h < block_sz; h++)
            arr[k*block_sz + h] = buf_R[j*block_sz + h];
        j++;
        k++;
    }
}

static void Merge_General(int arr[], int l, int m, int r){
    int h, i, j, k;
    int len_L = m - l + 1;
    int len_R = r - m;
    
    for(i = 0; i < len_L; i++)
        for(h = 0; h < block_sz; h++)
            buf_L[i*block_sz + h] = arr[(l + i)*block_sz + h];
    for(j = 0; j < len_R; j++)
        for(h = 0; h < block_sz; h++)
            buf_R[j*block_sz + h] = arr[(m + 1 + j) * block_sz + h];

    i = 0;
    j = 0;
    k = l;
    
    while (i < len_L && j < len_R){
        if ( (  (buf_L[i*block_sz + key1_idx] < buf_R[j*block_sz + key1_idx] && dir1 == ASCENDING) 
                ||  (buf_L[i*block_sz + key1_idx] > buf_R[j*block_sz + key1_idx] && dir1 == DESCENDING) 
              )
            ||
             (      (buf_L[i*block_sz + key1_idx] == buf_R[j*block_sz + key1_idx] )
                    &&  (   (buf_L[i*block_sz + key2_idx] <= buf_R[j*block_sz + key2_idx] && dir2 == ASCENDING)
                            ||  (buf_L[i*block_sz + key2_idx] >= buf_R[j*block_sz + key2_idx] && dir2 == DESCENDING)
                        )
             )
           ){
            for(h = 0; h < block_sz; h++)
                arr[k*block_sz + h] = buf_L[i*block_sz + h];
            i++;
        } else {
            for(h = 0; h < block_sz; h++)
                arr[k*block_sz + h] = buf_R[j*block_sz + h];
            j++;
        }
        k++;
    }
    while (i < len_L){
        for(h = 0; h < block_sz; h++)
            arr[k*block_sz + h] = buf_L[i*block_sz + h];
        i++;
        k++;
    }
    while (j < len_R){
        for(h = 0; h < block_sz; h++)
            arr[k*block_sz + h] = buf_R[j*block_sz + h];
        j++;
        k++;
    }
}

static void Merge_TwoArray(int arr_main[], int arr_aux[], int l, int m, int r){
    int h, i, j, k;
    int len_L = m - l + 1;
    int len_R = r - m;
    
    for(i = 0; i < len_L; i++) {
        for(h = 0; h < block_sz_main; h++)
            buf_L[i*block_sz_main + h] = arr_main[(l + i)*block_sz_main + h];
        for(h = 0; h < block_sz_aux; h++)
            buf_L_aux[i*block_sz_aux + h] = arr_aux[(l + i)*block_sz_aux + h];
    }
    for(j = 0; j < len_R; j++) {
        for(h = 0; h < block_sz_main; h++)
            buf_R[j*block_sz_main + h] = arr_main[(m + 1 + j) * block_sz_main + h];
        for(h = 0; h < block_sz_aux; h++)
            buf_R_aux[j*block_sz_aux + h] = arr_aux[(m + 1 + j) * block_sz_aux + h];
    }
 

    i = 0;
    j = 0;
    k = l;

    while (i < len_L && j < len_R){
        if ( (buf_L[i*block_sz_main] <= buf_R[j*block_sz_main] && dir == ASCENDING) 
                || (buf_L[i*block_sz_main] >= buf_R[j*block_sz_main] && dir == DESCENDING) ) {
            for(h = 0; h < block_sz_main; h++)
                arr_main[k*block_sz_main + h] = buf_L[i*block_sz_main + h];
            for(h = 0; h < block_sz_aux; h++)
                arr_aux[k*block_sz_aux + h] = buf_L_aux[i*block_sz_aux + h];
            i++;
        } else {
            for(h = 0; h < block_sz_main; h++)
                arr_main[k*block_sz_main + h] = buf_R[j*block_sz_main + h];
            for(h = 0; h < block_sz_aux; h++)
                arr_aux[k*block_sz_aux + h] = buf_R_aux[j*block_sz_aux + h];
            j++;
        }
        k++;
    } 
    while (i < len_L){
        for(h = 0; h < block_sz_main; h++)
            arr_main[k*block_sz_main + h] = buf_L[i*block_sz_main + h];
        for(h = 0; h < block_sz_aux; h++)
            arr_aux[k*block_sz_aux + h] = buf_L_aux[i*block_sz_aux + h];
        i++;
        k++;
    }
    while (j < len_R){
        for(h = 0; h < block_sz_main; h++)
            arr_main[k*block_sz_main + h] = buf_R[j*block_sz_main + h];
        for(h = 0; h < block_sz_aux; h++)
            arr_aux[k*block_sz_aux + h] = buf_R_aux[j*block_sz_aux + h];
        j++;
        k++;
    }
}

static void MergeSubSort_Int(int arr[], int l, int r){
    if (l < r) {
        int m = l + (r-l)/2;

        MergeSubSort_Int(arr, l, m);
        MergeSubSort_Int(arr, m+1, r);

        Merge_Int(arr, l, m, r);
    }
}

static void MergeSubSort_Block(int arr[], int l, int r){
    if (l < r) {
        int m = l + (r-l)/2;

        MergeSubSort_Block(arr, l, m);
        MergeSubSort_Block(arr, m+1, r);

        Merge_Block(arr, l, m, r);
    }
}

static void MergeSubSort_General(int arr[], int l, int r){
    if (l < r) {
        int m = l + (r-l)/2;

        MergeSubSort_General(arr, l, m);
        MergeSubSort_General(arr, m+1, r);

        Merge_General(arr, l, m, r);
    }
}

static void MergeSubSort_TwoArray(int arr_main[], int arr_aux[], int l, int r){
    if (l < r) {
        int m = l + (r-l)/2;

        MergeSubSort_TwoArray(arr_main, arr_aux, l, m);
        MergeSubSort_TwoArray(arr_main, arr_aux, m+1, r);

        Merge_TwoArray(arr_main, arr_aux, l, m, r);
    }
}

// _dir = 1 is ascending order
//     = 0 is descending order
void MergeSort_Int(int arr[], int N, int _dir){
    dir = _dir;
    buf_L = (int*) malloc(sizeof(int) * N);
    buf_R = (int*) malloc(sizeof(int) * N);
    MergeSubSort_Int(arr, 0, N-1);
    free(buf_L);
    free(buf_R);
}

// Naive merge sort for an array of specific data structure
void MergeSort_Block(int arr[], int N, int _dir, int _block_sz){
    dir = _dir;
    block_sz = _block_sz;
    buf_L = (int*) malloc(sizeof(int) * N * block_sz);
    buf_R = (int*) malloc(sizeof(int) * N * block_sz);
    MergeSubSort_Block(arr, 0, N-1);
    free(buf_L);
    free(buf_R);
}

// Merge sort for an array of specific data structure, and sorting is done wrt two keys in asc/desc order
void MergeSort_General(int arr[], int N, int _block_sz, int _key1_idx, int _dir1, int _key2_idx, int _dir2){
    dir1 = _dir1;
    dir2 = _dir2;
    key1_idx = _key1_idx;
    key2_idx = _key2_idx;
    block_sz = _block_sz;
    buf_L = (int*) malloc(sizeof(int) * N * block_sz);
    buf_R = (int*) malloc(sizeof(int) * N * block_sz);
    MergeSubSort_General(arr, 0, N-1);
    free(buf_L);
    free(buf_R);
}

// Naive merge sort for sorting two arrays at a time
// Sorting keys are in arr_main[], and arr_aux[] is sorted exactly the same as arr_main[]
void MergeSort_TwoArray(int arr_main[], int arr_aux[], int N, int _dir, int _block_sz_main, int _block_sz_aux){

    dir = _dir;
    block_sz_main = _block_sz_main;
    block_sz_aux  = _block_sz_aux;
    buf_L = (int*) malloc(sizeof(int) * N * block_sz_main);
    buf_R = (int*) malloc(sizeof(int) * N * block_sz_main);
    buf_L_aux = (int*) malloc(sizeof(int) * N * block_sz_aux);
    buf_R_aux = (int*) malloc(sizeof(int) * N * block_sz_aux);
    MergeSubSort_TwoArray(arr_main, arr_aux, 0, N-1);
    free(buf_L);
    free(buf_R);
    free(buf_L_aux);
    free(buf_R_aux);
}
