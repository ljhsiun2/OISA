//#include "pagerank.h"
#include <vector>
#include <tuple>
#include <iostream>

using namespace std;

/* TODO:
	--Implement Edge and Vertex better; feels wonky
	--What do with osort?
	--tuples in a vector legit?
	--This def doesn't compile; check and clean up
	--STL ok?
	--Should edge+vert be own classes? probs
	--data int vs class
	*/

class Edge{
public:
	Edge();


	int vbegin;
	int vend;
	bool isVertex;
	int data;
};
class Vertex{
public:
	Vertex();

	int vbegin;
	int vend;
	bool isVertex;
	int data_PR;
	int data_agg_val;
	int data_L;
	int degree;
};

class PageRank{
public:
	PageRank(vector<tuple<Edge, Vertex, int, int> > & G);

	void Scatter(vector<tuple<Edge, Vertex, int, int> > & G, int b);
	void Gather(vector<tuple<Edge, Vertex, int, int> > & G, int b);
	void Apply(vector<tuple<Edge, Vertex, int, int> > & G);

	void func_app(tuple<Edge, Vertex, int, int> &my_tuple);
	void func_sca(tuple<Edge, Vertex, int, int> &my_tuple, tuple<Edge, Vertex, int, int> u);
	void func_agg(tuple<Edge, Vertex, int, int> &my_tuple, int &agg_val);
	void func_con(tuple<Edge, Vertex, int, int> &my_tuple, int &agg_val);
private:
	vector<Edge> edges;
	vector<Vertex> vertices;
	vector<tuple<Edge, Vertex, int, int> > G;
};

/*void PageRank::insertVertex(vector<Vertex> &myV, vector<Edge> &myE, Vertex new_v){
    vsize = myV.size();
    esize = myE.size();
    
}*/

Edge::Edge(){
	data = 0;
	vbegin = 0;
	vend = 0;
	isVertex=0;
}

Vertex::Vertex(){
	vbegin = 1;
	vend = 1;
	isVertex = 1;
	data_PR = 0;
	data_agg_val = 0;
	data_L = 0;
	degree = 0;
}

PageRank::PageRank(vector<tuple<Edge, Vertex, int, int> > & G){
    /* TODO:
        --Insert_tuple function
        --Just initialization in general
    */
    int i =0;
    int K = 0; // what is k tho?
    for(i =0; i<K; i++)
    {
    	Scatter(G, 0); //0 = out, 1 = in
    	Gather(G, 1);
    	Apply(G);
    }
}

void PageRank::func_sca(tuple<Edge, Vertex, int, int> &my_tuple, tuple<Edge, Vertex, int, int> u){
	int uPR = get<1>(u).data_PR;
	int uL = get<1>(u).data_L;
	get<0>(my_tuple).data = uPR / uL;
}

void PageRank::func_agg(tuple<Edge, Vertex, int, int> &my_tuple, int & agg_val){
	agg_val = agg_val + get<0>(my_tuple).data;
}

void PageRank::func_con(tuple<Edge, Vertex, int, int> &my_tuple, int &agg_val){
	get<1>(my_tuple).data_agg_val = agg_val;
}

void PageRank::func_app(tuple<Edge, Vertex, int, int> &my_tuple){
	Vertex myV = get<1>(my_tuple);
	get<1>(my_tuple).data_PR = (0.15 / myV.degree) + 0.85*myV.data_agg_val;
}

void PageRank::Scatter(vector<tuple<Edge, Vertex, int, int> > & G, int b){
	int i =0;
	tuple<Edge, Vertex, int, int> scattered_vertex = G[0];
	// Insert osort here?
	for(i=0; i<G.size(); i++)
	{
		if(get<2>(G[i]))
			scattered_vertex = G[i];
		else
			func_sca(G[i], scattered_vertex);
	}
}

void PageRank::Gather(vector<tuple<Edge, Vertex, int, int> > & G, int b){
	// Insert osort here?
	int agg = 1;
	int i =0;
	for(i=0; i<G.size(); i++)
	{
		if(get<2>(G[i]))
		{
			func_con(G[i], agg);
			agg = 1;
		}
		else
			func_agg(G[i], agg);
	}
}

void PageRank::Apply(vector<tuple<Edge, Vertex, int, int> > & G){
	int i =0;
	for(i=0; i<G.size(); i++)
	{
		if(get<2>(G[i]))
			func_app(G[i]);
	}
}

int main(){
	cout << "Just cuz it compiles doesn't mean its right ¯\\_(ツ)_/¯ \n"; 
	cout << "In fact, I know it's not right cuz I still gotta do edges and vertices \n";

	Edge myEdge;
	Vertex myVert;

	vector<tuple<Edge, Vertex, int, int>> G = {make_tuple(myEdge, myVert, 1, 1)};
	PageRank PageRank(G);
	return 0;
}