#include <stdio.h>
#include <stdlib.h>
//#include "../multi2sim/bin/benchmarks/primitives/path_oram/oram.h"

#define MAT_SIZE 10

int matrix_mul(int* m1, int* m2){
	
	int retVal = 0;
	for(int i=0; i<MAT_SIZE; i++)
	{
		retVal += m1[i]*m2[i];
	}
	return (retVal < 0) ? 0 : retVal;
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
	for(int i =0; i<MAT_SIZE; i++)
	{
		arr3[i] = matrix_mul(arr1, arr2[i]);
		printf("Value in element %d: %d\n", i, arr3[i]);
	}
	


	return 0;
}