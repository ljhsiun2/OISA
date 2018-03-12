#include <stdio.h>
#include "../benchmarks/primitives/path_oram/oram.h"

int main(){
	Init_ORAM(32, 11, 1, 50); // what is bucket size and C again?
	// just use argc if you dont hardcode 
	int* arr = (int*) malloc(sizeof(int)*11*1);
	int i=0;
	int best = 0;
	for(i = 0; i<10; i++)
	{
		arr[i] = i;
		Access_ORAM(WRITE, i, arr+i);
		printf("Arr value at i: %d\n", arr[i]);
	}

	for(i=0; i<10; i++)
	{
		if(best < arr[i])
			Access_ORAM(READ, i, &best);
		printf("best value: %d \n", best);
	}
	printf("Largest int found: %d \n", best);
	return 0;
}