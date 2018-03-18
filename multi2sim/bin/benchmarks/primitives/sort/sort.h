#ifndef __SORT_HEADER__
#define __SORT_HEADER__

#define ASCENDING   1
#define DESCENDING  0

/******************************************************
 *  Non-Oblivious Sorting Algorithm
 *****************************************************/
// Naive merge sort for integer array
void MergeSort_Int(int arr[], int N, int dir);

// Naive merge sort for an array of specific data structure
void MergeSort_Block(int arr[], int N, int key_idx, int dir, int block_sz);

// Merge sort for an array of specific data structure, and sorting is done wrt two keys in asc/desc order
void MergeSort_General(int arr[], int N, int block_sz, int key1_idx, int dir1, int key2_idx, int dir2);

// Naive merge sort for sorting two arrays at a time
// Sorting keys are in arr_main[], and arr_aux[] is sorted exactly the same as arr_main[]
void MergeSort_TwoArray(int arr_main[], int arr_aux[], int N, int key_idx, int dir, int block_sz_main, int block_sz_aux);

void MergeSort_TwoArray_TwoKey(int arr_main[], int arr_aux[], int N, int key1_idx, int dir1, int key2_idx, int dir2, int block_sz_main, int block_sz_aux);



/******************************************************
 * Oblivious Sorting Algorithm
 *****************************************************/
// Bitonic sort for integer array
void BitonicSort_Int(int arr[], int N, int dir);

// Bitonic sort for an array of specific data structure
// Requirements: 1. size of individual object is _block_sz * sizeof(int)
//               2. number of objects to sort is N
//               3. integer key stays at the first sizeof(int) bytes of each block
void BitonicSort_Block(int arr[], int N, int key_idx, int dir, int block_sz);

// Bitonic sort for an array of specific data structure, and sorting is done wrt two keys in asc/desc order
void BitonicSort_General(int arr[], int N, int block_sz, int key1_idx, int dir1, int key2_idx, int dir2);

// Bitonic sort for sorting two arrays at a time
// Sorting keys are in arr_main[], and arr_aux[] is sorted exactly the same as arr_main[]
// Requirements: 1. size of individual of arr_main[] is _block_sz_main * sizeof(int)
//                                        arr_aux[]  is _block_sz_aux  * sizeof(int)
//               2. number of objects to sort is N, same in arr_main[] and arr_aux[]
//               3. integer key stays at the first sizeof(int) bytes of each block in arr_main[]
void BitonicSort_TwoArray(int arr_main[], int arr_aux[], int N, int key_idx, int dir, int block_sz_main, int block_sz_aux);

void BitonicSort_TwoArray_TwoKey(int arr_main[], int arr_aux[], int N, int key1_idx, int dir1, int key2_idx, int dir2, int block_sz_main, int block_sz_aux);




#endif
