#include <stdio.h>
#include "heap.h"

static int size = 0;
/* SEE main.c for examples on using access_oram (tl;dr id = index, ptr = start of array*/
int ExtractMin(){
	ODS.Start() // still not sure what this is
	struct node_t list[200];
	readPath(list);
	int retKey = list[0].key;
	list[0].key = list[size-1].key;
	size--;
	for(int i = size; i>=0; i--)
		Access_ORAM(WRITE, list[i].nodeid, list[i].key);

	int nodeid = 1;
	while(nodeid <= size)
	{
		key = Access_ORAM(READ, nodeid, NULL); // is null even a legal thing? idk
		lkey = Access_ORAM(READ, 2*nodeid, NULL);
		rkey = Access_ORAM(READ, 2*nodeid + 1, NULL);

		if(rkey < lkey)
		{
			if(key >= rkey)
			{
				Access_ORAM(WRITE, nodeid, rkey);
				nodeid = nodeid *2 + 1;
			}
		}
		else{
			if(key >= lkey)
			{
				Access_ORAM(WRITE, nodeid, lkey);
				nodeid *= 2;
			}
		}
		Access_ORAM(WRITE, nodeid, key);
	}
	ODS.Finalize();
	return retKey;
}

void readPath(struct node_t& list[]){
	int nodeid=1, level = 1;
	int key;
	int nodeid_checker = 1;
	int i =0;
	while(nodeid < 200)
	{
		int data;
		Access_ORAM(READ, nodeid, &data);
		list[i].key = data.key;
		list[i].nodeid = nodeid;
		if(!(nodeid_checker % 2))
			nodeid *= 2;
		else
			nodeid = nodeid * 2 + 1;
		nodeid_checker = nodeid >> level;
		i++;
		level++;
	}
}

void insert(int key){
	Init_ORAM(); // is start initiated every single time? I think ods.start is 
				// diff than ods.init? malloc?
	struct node_t ret_list[200];
	struct node_t new_node;
	readPath(list);

	new_node.key = key;
	new_node.nodeid = size;
	list[size] = key;
	size++;
	
	for(int i = size; i>=1; i--)
	{
		if(list[i].key > list[i-1].key)
		{
			struct node_t temp = list[i];
			list[i] = list[i-1];
			list[i-1] = temp;
		}
	}
	for(int i = size; i>=0; i--)
		Access_ORAM(WRITE, list[i].nodeid, list[i].key);
	ODS.finalize??
}

int main(){
	struct node_t test_list[200];
	insert(0);
	readPath(list);
}