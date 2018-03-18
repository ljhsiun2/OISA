#include <stdio.h>
#include "../multi2sim/bin/benchmarks/primitives/path_oram/path_oram.h"

#define Z 4
#define N 11
#define B 1
#define C 50
#define SORT_TYPE 1 // 1 for bitonic, 0 for merge

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

static inline void cmovn(int cond, int* src_ptr, int* dst_ptr, int sz){
    for(int i = 0; i < sz; i++){
        /*printf("src_ptr+i = %p, dst_ptr+i = %p\n", src_ptr+i, dst_ptr+i);*/
        cmov(cond, src_ptr+i, dst_ptr+i);
    }
}

int main(){
	Init_ORAM(Z, N, B, C, SORT_TYPE);
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
	int flag = 0;
	for(int i =0; i<log16; i++) // what do here as well
	{
		m = l+(r-l)/2;
		printf("pre-Value in m: %d\n", m);
		Access_ORAM(READ, m, &tempVal);
				printf("post-Value in m: %d\n", m);

		if(tempVal == search)
			flag=1; //what do here

		if(tempVal < search)
			l = m+1;
		else
			r = m-1;
	}

	printf("Element found at index %d \n", m);
	//int arr[] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9};
	return 0;
}