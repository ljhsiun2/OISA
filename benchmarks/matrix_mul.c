#include <stdio.h>
#include <stdlib.h>
#include "../benchmarks/primitives/path_oram/oram.h"

int main(){
	Init_ORAM(32, 10, 1, 50, 1);
	int* arr1 = (int*) malloc(sizeof(int)*11*1);
	int* arr2 = (int*) malloc(sizeof(int)*11*1);
	int* arr3 = (int*) malloc(sizeof(int)*11*1);

	int tempSum;

	for(int i = 0; i<5; i++)
	{	
		printf("Value in arr3 is: ");
		for(int j=0; j<5; j++)
		{

			Access_ORAM(WRITE, i, arr1+j*i+i);
			Access_ORAM(WRITE, j, arr2+j*i+i);
			Access_ORAM(WRITE, i*j, arr3+j*i+i);

			/*arr1[i*(j+1)] = j;
			arr2[i*(j+1)] = i;
			arr3[i*(j+1)] = arr1[i*(j+1)] * arr2[i*(j+1)];*/
			printf("%d, ", arr3[i*(j+1)]);
		}
		printf("\n");
	}

	free(arr1);
	free(arr2);
	free(arr3);
	return 0;
}