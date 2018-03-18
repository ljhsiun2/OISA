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
	int PR; // initialized for all Vertices to have 1/|V|
	int num_edges;
	int agg;

	// "value of weighted contribution of PageRank of outgoing vertex u" idk lol
	int edge_weight;
} tuple;

typedef struct data_t{
	// vertex values; PR and degree of it

} data;

//typedef vector<tuple<int, int, bool, data> > Graph;

int Fs(struct data_t* u_data){
	return (u_data->PR/u_data->num_edges);
}

int Fg(int e_data, int u_data){
	return e_data + u_data;
}

int Fa(struct data_t* v_data){
	return ((.15/v_data->PR)+ .85*v_data->agg); 
}

/* This is specialized for "out"? */
void Scatter(struct tuple_t** G){
	BitonicSort_General((int*) G, M, sizeof(struct tuple_t)/sizeof(int), 0, 1, 2, 1);
	struct data_t* tempVal;
	for(int i = 0; i<M; i++)
	{
		if(G[i]->isVertex)
			tempVal = G[i]->data;
		else
			G[i]->data->edge_weight = Fs(tempVal);
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
			G[i]->data->agg = agg; // what is || operation, concat?
			agg = 1;				// default?
		}
		else
			agg = Fg(agg, G[i]->data->agg);
	}
}

void Apply(struct tuple_t** G){
	for(int i =0; i<M; i++)
		G[i]->data->PR = Fa(G[i]->data);
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
	{
		G[i] = malloc(sizeof(struct tuple_t));
		G[i]->data = malloc(sizeof(struct data_t));
	}
	computePageRank(G);
	for(int i=0; i<M; i++)
	{
		free(G[i]->data);
		free(G[i]);
	}
}