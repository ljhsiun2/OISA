#include <stdio.h>
#include "../benchmarks/primitives/path_oram/oram.h"

int main(){
	Init_ORAM(32, 11, 1, 50);
	int* arr = (int*) malloc(sizeof(int)*11*1);
	for(int i = 0; i<10; i++)
	{
		arr[i] = i;
		Access_ORAM(WRITE, i, arr+i);
		printf("Arr value at i: %d\n", arr[i]);
	}

	int l=0, r = 9, search=3; // search = search element
	int m;
	int tempVal;
	while(l<=r)
	{
		m = l+(r-l)/2;
		printf("pre-Value in m: %d\n", m);
		Access_ORAM(READ, m, &tempVal);
				printf("post-Value in m: %d\n", m);

		if(tempVal == search)
			break;

		if(tempVal < search)
			l = m+1;
		else
			r = m-1;
	}

	printf("Element found at index %d \n", m);
	//int arr[] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9};
	return 0;
}