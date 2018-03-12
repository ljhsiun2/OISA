#include <vector>
#include <iostream>
#include <queue>
#include <limits.h>
#include "./primitives/path_oram/oram.h"

using namespace std;

class Graph{
public:
	Graph(int nodes);

	void addEdge(int u, int v, int weight);
	void findPath(int u);
	vector<pair<int, int> > *vertex;		// vertex[u] returns pair(v, weight)
};

Graph::Graph(int nodes){
	Init_ORAM(4, nodes, 1, 50);
	// bucketsize=4
	// num_blocs = num blocks you want
	// blocksize, how large thesee blcoks are (1 is a word)
	// C = 50
	// where to get id
	this->vertex = new vector<pair<int, int> > [nodes];
}

void Graph::addEdge(int u, int v, int w){
	// Access_ORAM(write, id, *ptr)
	// Aceess(WRITE, vertex[u], &vertex[u])
	vertex[u].push_back(make_pair(v, w)); // add element at very end
	vertex[v].push_back(make_pair(u, w)); // make pair for u, v
}

void Graph::findPath(int u){
	priority_queue< pair<int, int>, vector<pair<int, int>>, greater<pair<int, int>> > my_pq;

	vector<int> dist(8, INT_MAX);
 
    my_pq.push(make_pair(0, u));
    dist[u] = 0;
 
    while (!my_pq.empty())
    {
        int p = my_pq.top().second;
        my_pq.pop();
 
        vector< pair<int, int> >::iterator i;
        for (i = vertex[p].begin(); i != vertex[p].end(); ++i)
        {
            int q = (*i).first;
            int weight = (*i).second;
 
            if (dist[q] > dist[p] + weight)
            {
                dist[q] = dist[p] + weight;
                my_pq.push(make_pair(dist[q], q));
            }
        }
    }
 
    // Print shortest distances stored in dist[]
    printf("Vertex   Distance from Source\n");
    for (int i = 0; i < 8; ++i)
        printf("%d \t\t %d\n", i, dist[i]);

}

int main(){
	//Init_ORAM_Controller(xx); what are these functions though

	Graph lol(8);

	// use graph here https://web.stanford.edu/class/archive/cs/cs106b/cs106b.1152/preview-dijkstra.shtml
	// (a, 0), (b, 1), (c, 2), (d, 3), (e, 4), (f, 5), (g, 6), (h, 7)
	lol.addEdge(0, 1, 4);
	lol.addEdge(0, 4, 7);
	lol.addEdge(0, 3, 2);
	lol.addEdge(1, 4, 2);
	lol.addEdge(3, 6, 1);
	lol.addEdge(3, 7, 4);
	lol.addEdge(6, 7, 2);

	lol.addEdge(1, 4, 2);
	lol.addEdge(4, 5, 2);
	lol.addEdge(7, 4, 5);
	lol.addEdge(7, 5, 1);

	lol.addEdge(2, 4, 4);
	lol.addEdge(5, 2, 1);

	lol.findPath(1);
	return 0;
}


