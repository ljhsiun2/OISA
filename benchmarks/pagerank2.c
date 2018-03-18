#include <stdio.h>
#include <stdlib.h>
#include "../multi2sim/bin/benchmarks/primitives/path_oram/path_oram.h"
#include "../multi2sim/bin/benchmarks/primitives/sort/sort.h"

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

typedef struct tuple_t{
	int vertex;
	int edge;
	int isVertex;

	// insert data struct below
	int PR; // initialized for all Vertices to have 1/|V|
	int num_edges;
	int agg;

	// "value of weighted contribution of PageRank of outgoing vertex u" idk lol
	int edge_weight;
} tuple;

//typedef vector<tuple<int, int, bool, data> > Graph;

int Fs(struct tuple_t* u_data){
	return (u_data->PR/u_data->num_edges);
}

int Fg(int e_data, int u_data){
	return e_data + u_data;
}

int Fa(struct tuple_t* v_data){
	return ((.15/v_data->PR)+ .85*v_data->agg); 
}

/* This is specialized for "out"? */
void Scatter(struct tuple_t** G){
	BitonicSort_General((int*) G, M, sizeof(struct tuple_t)/sizeof(int), 0, 1, 2, 1);
	struct tuple_t* tempVal;
	for(int i = 0; i<M; i++)
	{
		if(G[i]->isVertex)
			tempVal = G[i];
		else
			G[i]->edge_weight = Fs(tempVal);
	}
}

/* This is specialized for "in"? */
void Gather(struct tuple_t** G){
	BitonicSort_General((int*) G, M, sizeof(struct tuple_t)/4, 1, 1, 2, 0);
	int agg = 1;
	for(int i =0; i<M; i++)
	{
		if(G[i]->isVertex)
		{
			G[i]->agg = agg; // what is || operation, concat?
			agg = 1;				// default?
		}
		else
			agg = Fg(agg, G[i]->agg);
	}
}

void Apply(struct tuple_t** G){
	for(int i =0; i<M; i++)
		G[i]->PR = Fa(G[i]);
}

void computePageRank(struct tuple_t** G){
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
	2) Give each vertex initial v->data.PR = 1/|V|
	*/
	struct tuple_t* G[M];
	for(int i = 0; i<M; i++)
		G[i] = malloc(sizeof(struct tuple_t));

	computePageRank(G);
	for(int i=0; i<M; i++)
		free(G[i]);
}