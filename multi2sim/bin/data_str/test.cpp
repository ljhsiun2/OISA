#include <stdio.h>

struct test_t {
	int a;
	int b;
} x, y, z;

void test(struct test_t* test);

void test(struct test_t* test){
	test->a = -1;
	test->b = -1;
}

int main(){
	struct test_t my_arr[3];
	x.a = 0;
	x.b = 1;
	y.a = 5;
	y.b = 6;
	z.a = 10;
	z.b = 11;
	my_arr[0] = x;
	my_arr[1] = y;
	my_arr[2] = z;

	for(int i =0; i<3; i++)
		printf("Before test: %d: a %d, b %d \n", i, my_arr[i].a, my_arr[i].b);
	for(int i =0; i<3; i++)
		test(&my_arr[i]);
	for(int i =0; i<3; i++)	
		printf("After test: %d: a %d, b %d \n", i, my_arr[i].a, my_arr[i].b);
	return 0;
}