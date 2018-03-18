#include <stdio.h>
#include "../multi2sim/bin/benchmarks/primitives/path_oram/path_oram.h"

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
	printf("starting program\n");
	// just use argc if you dont hardcode 
	int* arr = (int*) malloc(sizeof(int)*10*1);
	int i=0;
	int best = 0;
	for(i = 0; i<10; i++)
	{
		arr[i] = i;
		//Access_ORAM(WRITE, i, arr+i);
		printf("Arr value at i: %d\n", arr[i]);
	}

	for(i=0; i<10; i++)
	{
		cmov((best < arr[i]), &arr[i], &best);
		printf("best value: %d \n", best);
	}
	printf("Largest int found: %d \n", best);
	free(arr);
	return 0;
}