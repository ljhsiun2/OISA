#ifndef _HEAP_H_
#define _HEAP_H_

#include "../benchmarks/primitives/path_oram/oram.h"

struct node_t {
	int key;
	int nodeid;
}

int ExtractMin();

class Heap
{
public:
	int* readPath();
	void insert(int key);
};

#endif