// oram_depth is actually the real depth + 1
#ifndef __ORAM_HEADER__
#define __ORAM_HEADER__

#include <stdint.h>

#define READ  1
#define WRITE 2

enum Sort_Scheme {
    MERGE_SORT,
    BITONIC_SORT
};

//#define ENABLE_PRINT
// NOTE this works only for local run(without simulation).
//#define MEASURE_FUNC_TIME

typedef struct {
    int           valid;
    int           id;
    int           leaf;
} ORAM_Block;

typedef struct {
    int           depth;
    int*          oram;
} ORAM_Tree;

typedef struct {
    int           valid;
    int           id;
    int           leaf;
} PosMap_Entry;

typedef struct {
    int           size;
    PosMap_Entry* entries;
} PosMap;

typedef struct {
    int           key;
    int           valid;
    int           id;
    int           leaf;
} Stash_Info;

typedef struct {
    int           size;
    Stash_Info*   info;
    int*          data;
} Stash;

typedef struct {
    int           block_size;     // number of words(4 bytes) in each block
    int           bucket_size;
    int           num_buckets;
    int           num_leaves;
    PosMap        pos_map;
    Stash         stash;
} ORAM_Controller;


extern ORAM_Tree        oram_tree;
extern ORAM_Controller  oram_controller;


#ifdef MEASURE_FUNC_TIME
extern uint64_t time_Free_ORAM;
extern uint64_t time_Init_ORAM;
extern uint64_t time_Init_ORAM_Controller;
extern uint64_t time_Init_ORAM_Tree;
extern uint64_t time_Init_PosMap;
extern uint64_t time_Init_Stash;
extern uint64_t time_Access_ORAM;
extern uint64_t time_Retrieve_LeafLabel;
extern uint64_t time_Store_Blocks;
extern uint64_t time_Fetch_Blocks;
#endif


int GenRandLeaf();  // TODO: consider using TRNG

int PushBack();

void Init_Stash(int stash_size);

void Init_PosMap(int posmap_size);

void Init_ORAM_Controller(int bucket_size, int oram_depth, int block_size, int num_real_blocks, int C);

void Init_ORAM_Tree(int bucket_size, int oram_depth, int block_size);

/// Initialize ORAM structure
//  Total number of blocks = bucket_size *  (2 ^ oram_depth - 1)
void Init_ORAM(int bucket_size, int num_real_blocks, int block_size, int C, enum Sort_Scheme sort_scheme);

/// Free whole ORAM
void Free_ORAM();

/// Generate the path to fetch
//  Change posmap to reflect new_leaf
int Retrieve_LeafLabel(int op, int id, int* access_leaf_ptr, int* new_leaf_ptr);

/// Fetch path from ORAM_Tree to Stash 
//  When implemented in SW, posmap / stash can be a linked-list structure rather than RAM
//  This is not true. Traverse array outperforms traverse linked list(locality)
void Fetch_Blocks(int op, int id, int* data_ptr, int access_leaf, int new_leaf);

/// Store path from Stash to ORAM_Tree
//  stash eviction logic refers to Tiny ORAM paper
void Store_Blocks(int access_leaf);

/// Access ORAM by op==READ or op==WRITE
//  for READ, the data will be placed at data_ptr
//  for WRITE, data_ptr provides data to write into ORAM
void Access_ORAM(int op, int id, int* data_ptr);

/// Return the posmap entry index which has id and is valid
//  if not find this id, return -1
int Find_PosMap(int id);

/// Return 1 if posmap is full, 0 if posmap has empty slots
int PosMap_Full();

/// Return 1 if stash is full, 0 if stash has empty slots
int Stash_Full();

void Print_Func_Time_Stats(uint64_t total_time);

#ifdef ENABLE_PRINT
void Print_All();

void Print_ORAM();

void Print_Stash();

void Print_PosMap();
#endif



#endif
