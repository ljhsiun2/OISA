#include <stdio.h>
#include <stdlib.h>
#include "benchmarks/primitives/path_oram/oram.h"
#include "benchmarks/primitives/sort/sort.h"

#define M 60 // imagine a simple directed graph w/ 20 nodes
#define K 5	// what is K tho? num of vertices?

/* TODO:
	-- Double check what || and +/- mean
	-- Check what "agg" is
	-- clean up struct stuff? maybe?
	-- Figure out K
	-- Figure out osort
	-- Make it into C so it plays nice with generalSort
	heyyyyy 95% done 
	*/

typedef struct Graph_t{

} Graph;

typedef struct tuple_t{
	int vertex;
	int edge;
	bool isVertex;
	struct data;
} tuple;

typedef struct data_t{
	// vertex values; PR and degree of it
	int PR; // initialized for all Vertices to have 1/|V|
	int num_edges;
	int agg;

	// "value of weighted contribution of PageRank of outgoing vertex u" idk lol
	int edge_weight;
} data;

typedef vector<tuple<int, int, bool, data> > Graph;

int Fs(data u_data){
	return (u_data.PR/u_data.num_edges);
}

int Fg(int e_data, int u_data){
	return e_data + u_data;
}

int Fa(data v_data){
	return ((.15/v_data.PR)+ .85*v_data.agg); 
}

/* This is specialized for "out"? */
void Scatter(Graph & G){
	BitonicSort_General(int arr[], int N, int _block_sz, int _key1_idx, int _dir1, int _key2_idx, int _dir2);
	data tempVal;
	for(int i = 0; i<M; i++)
	{
		if(get<2>(G[i]))
			tempVal = get<3>(G[i]);
		else
			get<3>(G[i]).edge_weight = Fs(tempVal);
	}
}

/* This is specialized for "in"? */
void Gather(Graph & G){
	BitonicSort_General(int arr[], int N, int _block_sz, int _key1_idx, int _dir1, int _key2_idx, int _dir2);
	int agg = 1;
	for(int i =0; i<M; i++)
	{
		if(get<2>(G[i]))
		{
			get<3>(G[i]).agg = agg; // what is || operation, concat?
			agg = 1;				// default?
		}
		else
			agg = Fg(agg, get<3>(G[i]).agg);
	}
}

void Apply(Graph & G){
	for(int i =0; i<M; i++)
		get<3>(G[i]).PR = Fa(get<3>(G[i]));
}

void computePageRank(Graph & G){
	for(int i =0; i<K; i++)
	{
		Scatter(G);
		Gather(G);
		Apply(G);
	}
}

int main(){

	/* Initialization steps:
	1) Fill G
	2) Give each vertex initial v.data.PR = 1/|V|
	*/
	struct tuple_t G[60];
	for(int i = 0; i<60; i++)
		G[i] = (struct tuple_t) malloc(sizeof(tuple_t));
	computePageRank(G);
}