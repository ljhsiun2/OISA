#include "sort.h"

int* buf_L, buf_R;

static void Merge(int arr[], int l, int m, int r, int dir){
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
        if ( (L[i] <= R[j] && dir == ASCENDING) || (L[i] >= R[j] && dir == DESCENDING) ) {
            arr[k] = L[i];
            i++;
        } else {
            arr[k] = R[j];
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

static void MergeSubsort(int arr[], int l, int r, int dir){
    if (l < r) {
        int m = l + (r-l)/2;

        MergeSubsort(arr, l, m, dir);
        MergeSubsort(arr, m+1, r, dir);

        Merge(arr, l, m, r, dir);
    }
}

// dir = 1 is ascending order
//     = 0 is descending order
void MergeSort(int arr[], int N, int dir){
    buf_L = (int*) malloc(sizeof(int) * N);
    buf_R = (int*) malloc(sizeof(int) * N);
    MergeSubsort(arr, 0, N-1, dir);
    free(buf_L);
    free(buf_R);
}

