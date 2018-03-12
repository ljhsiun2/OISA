#ifndef __SORT_HEADER__
#define __SORT_HEADER__

#define ASCENDING   1
#define DESCENDING  0

// Bitonic sort for integer array
void BitonicSort_i(int arr[], int N, int dir);

// Bitonic sort for an array of specific data structure
// Requirements: 1. size of data structure is block_sz * sizeof(int)
//               2. number of data structures is num_blocks
//               3. integer key stays at the first sizeof(int) bytes of each block
void BitonicSort_T(int arr[], int num_blocks, int dir, int block_sz);

void MergeSort(int arr[], int N, int dir);

#endif
