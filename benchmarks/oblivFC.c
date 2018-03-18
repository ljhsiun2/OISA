#include <stdio.h>
#include <stdlib.h>
#include "/home/ljhsiun2/projects/research/multi2sim/bin/benchmarks/primitives/path_oram/path_oram.h"

#define MAT_SIZE 10
#define NUM_LAYERS 5

static inline void cmov(int cond, int* src_ptr, int* dst_ptr){
    __asm__ __volatile__ (  "movl (%2), %%eax\n\t"
                            "testl %0, %0\n\t"
                            "cmovnel (%1), %%eax\n\t"
                            "movl %%eax, (%2)"
                            :
                            : "b" (cond), "c" (src_ptr), "d" (dst_ptr)
                            : "cc", "%eax", "memory"
            );
}

int dot_prod(int* m1, int* m2){
	
	int temp = 0;
	int retVal = 0;
	for(int i=0; i<MAT_SIZE; i++)
	{
		temp += m1[i]*m2[i];
	}
	cmov((temp > 0), &temp, &retVal);
	return retVal;
}

int main(){
	int arr1[MAT_SIZE] = {2, 1, 5, 7, 8, 2, 3, 4, 9};
	int arr2[MAT_SIZE][MAT_SIZE] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
									1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
									2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
									3, 3, 3, 3, 3, 3, 3, 3, 3, 3,
									4, 4, 4, 4, 4, 4, 4, 4, 4, 4,
									5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
									6, 6, 6, 6, 6, 6, 6, 6, 6, 6,
									7, 7, 7, 7, 7, 7, 7, 7, 7, 7,
									8, 8, 8, 8, 8, 8, 8, 8, 8, 8,
									9, 9, 9, 9, 9, 9, 9, 9, 9, 9};

									
	int arr3[MAT_SIZE];
	for(int wat = 0; wat < NUM_LAYERS; wat++)
	{
		for(int i =0; i<MAT_SIZE; i++)
		{
			arr3[i] = dot_prod(arr1, arr2[i]);
			
		}
		printf("Values in layer %d: ", wat);
		for(int i =0; i <MAT_SIZE; i++)
		{
			printf("%d ", arr3[i]);
			arr1[i] = arr3[i];
		}
		printf("\n");
	}	


	return 0;
}