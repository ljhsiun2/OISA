#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#include "path_oram.h"
#include "../lib/asm.h"
#include "../lib/defs.h"
#include "../lib/misc.h"
#include "../sort/sort.h"
#include "../scan_oram/scan_oram.h"

int seed    = 111111;
int zero    = 0;
int one     = 1;
int max_int = 0xfffffff;

int POSMAP_LEAF_MASK   = 0x7FFF;
int POSMAP_VALID_MASK  = 0x8000;

ORAM_Tree       oram_tree;
ORAM_Controller oram_controller;
void (*store_sort_func)(int*, int*, int, int, int, int, int, int, int);

// data structure used in store blocks
int* wb_path = NULL;
int* occupied = NULL;

#ifndef M2S
uint64_t time_Free_ORAM;
uint64_t time_Init_ORAM;
uint64_t time_Init_ORAM_Tree;
uint64_t time_Init_ORAM_Controller;
uint64_t time_Init_PosMap;
uint64_t time_Init_Stash;
uint64_t time_Access_ORAM;
uint64_t time_Retrieve_LeafLabel;
uint64_t time_Store_Blocks;
uint64_t time_Fetch_Blocks_1;
uint64_t time_Fetch_Blocks_2;
uint64_t time_Sort;
uint64_t total_time;
#endif




int GenRandLeaf () {  // TODO: consider using TRNG
    int result = rand() % oram_controller.num_leaves;
    return result;
}

int PushBack(int accessed_leaf, int stash_leaf, int* occupied, int L){

    int t1 = bitwiseReverse(accessed_leaf, L) ^ bitwiseReverse(stash_leaf, L);
    int t2 = t1 & (-t1);
    int t3 = t2 - 1;
    int full = 0;
    for(int i = 0; i < L; i++){
        if (occupied[i] == oram_controller.bucket_size)
            full += 1 << i;
    }
    int t4 = t3 & ~full;
    int t5 = bitwiseReverse(t4, L);
    int t6 = t5 & (-t5);
    int t7 = bitwiseReverse(t6, L);

    if (t3 == 0 && occupied[0] < oram_controller.bucket_size)
        return 0;
    else if (t7 == 0)
        return -1;
    else
        return log_2(t7);
}

void Init_Stash (int stash_size) {
#ifdef MEASURE_FUNC_TIME
    uint64_t begin = rdtsc();
#endif

    oram_controller.stash.size = stash_size;
    oram_controller.stash.info = (Stash_Info*) calloc(sizeof(Stash_Info), stash_size);
    oram_controller.stash.data = (int*) malloc(sizeof(int) * oram_controller.block_size * stash_size);

    // Uncomment these if using malloc instead of calloc
    /*for (int i = 0; i < oram_controller.stash.size; i++)*/
        /*oram_controller.stash.info[i].valid = 0;*/

#ifdef MEASURE_FUNC_TIME
    time_Init_Stash = time_Init_Stash + rdtsc() - begin;
#endif
}

void Init_PosMap (int posmap_size) {
#ifdef MEASURE_FUNC_TIME
    uint64_t begin = rdtsc();
#endif

    oram_controller.pos_map.size    = posmap_size;
    oram_controller.pos_map.entries = (uint16_t*) calloc(sizeof(uint16_t), posmap_size);

    // Uncomment these if using malloc instead of calloc
    /*for (int i = 0; i < oram_controller.pos_map.size; i++)*/
        /*oram_controller.pos_map.entries[i] &= ~POSMAP_VALID_MASK*/

#ifdef MEASURE_FUNC_TIME
    time_Init_PosMap = rdtsc() - begin;
#endif
}

void Init_ORAM_Controller (int bucket_size, int oram_depth, int block_size, int C, int num_real_blocks) {
#ifdef MEASURE_FUNC_TIME
    uint64_t begin = rdtsc();
#endif

    oram_controller.block_size  = block_size;
    oram_controller.bucket_size = bucket_size;
    oram_controller.num_buckets = (1 << oram_depth) - 1;
    oram_controller.num_leaves  = 1 << (oram_depth - 1);

    int posmap_size = num_real_blocks;
    int stash_size = roundToPowerOf2(oram_controller.bucket_size * oram_depth + C);

    Init_PosMap(posmap_size);
    Init_Stash(stash_size);

#ifdef MEASURE_FUNC_TIME
    time_Init_ORAM_Controller = time_Init_ORAM_Controller + rdtsc() - begin;
#endif
}

void Init_ORAM_Tree (int bucket_size, int oram_depth, int block_size) {
#ifdef MEASURE_FUNC_TIME
    uint64_t begin = rdtsc();
#endif

    oram_tree.depth = oram_depth;
    oram_tree.oram  = (int*) malloc((sizeof(ORAM_Block) + block_size * sizeof(int)) * bucket_size * (1 << oram_depth));

    for (int i = 0; i < (1<<oram_depth) * bucket_size; i++) {
        ORAM_Block* oram_block = &oram_tree.oram[sizeof(ORAM_Block) / sizeof(int) + block_size];
        oram_block->valid = 0;
    }

#ifdef MEASURE_FUNC_TIME
    time_Init_ORAM_Tree = time_Init_ORAM_Tree + rdtsc() - begin;
#endif
}

void Init_ORAM (int bucket_size, int num_real_blocks, int block_size, int C, enum Sort_Scheme sort_scheme) {
#ifdef MEASURE_FUNC_TIME
    uint64_t begin = rdtsc();
#endif

    srand(seed);

    int oram_depth = log_2(num_real_blocks);

    assert(oram_depth <= 15);

    Init_ORAM_Controller(bucket_size, oram_depth, block_size, C, num_real_blocks);
    Init_ORAM_Tree(bucket_size, oram_depth, block_size);

    wb_path = (int*) malloc(sizeof(int) * oram_tree.depth * oram_controller.bucket_size);
    occupied = (int*) malloc(sizeof(int) * oram_tree.depth);

    if (sort_scheme == MERGE_SORT){
        store_sort_func = &MergeSort_TwoArray_TwoKey;
    }
    else if (sort_scheme == BITONIC_SORT){
        store_sort_func = &BitonicSort_TwoArray_TwoKey;
    }
    else
        assert(0);

#ifdef MEASURE_FUNC_TIME
    time_Init_ORAM = time_Init_ORAM + rdtsc() - begin;
#endif
}

void Free_ORAM() {
#ifdef MEASURE_FUNC_TIME
    uint64_t begin = rdtsc();
#endif
    
    /// Free posmap
    free(oram_controller.pos_map.entries);

    /// Free Stash
    free(oram_controller.stash.info);
    free(oram_controller.stash.data);

    /// Free ORAM Tree
    free(oram_tree.oram);

    /// Other structures
    free(wb_path);
    free(occupied);


#ifdef MEASURE_FUNC_TIME
    time_Free_ORAM = time_Free_ORAM + rdtsc() - begin;
#endif
}

int Retrieve_LeafLabel(int op, int id, int* access_leaf_ptr, int* new_leaf_ptr) {
#ifdef MEASURE_FUNC_TIME
    uint64_t begin = rdtsc();
#endif

    int id_match = 0;
    int id_match_valid = 0;
    int id_match_invalid = 0;
    int if_new_data = 0;

    for (int i = 0; i < oram_controller.pos_map.size; i++) {
        uint16_t* posmap_entry = &oram_controller.pos_map.entries[i];
        int posmap_entry_leaf = (*posmap_entry & POSMAP_LEAF_MASK);
        int posmap_entry_valid = (*posmap_entry & POSMAP_VALID_MASK);

        // access the associated path if it's valid; otherwise don't change access_leaf
        id_match = (id == i);
        id_match_valid = id_match && posmap_entry_valid;
        id_match_invalid = id_match && !posmap_entry_valid;
        if_new_data = if_new_data || id_match_invalid;
        cmov(id_match_invalid,  &POSMAP_VALID_MASK, &posmap_entry_valid);
        cmov(id_match_valid,    &posmap_entry_leaf, access_leaf_ptr);
        cmov(id_match,          new_leaf_ptr,       &posmap_entry_leaf);

        *posmap_entry = (uint16_t) (posmap_entry_leaf | posmap_entry_valid);
    }

    if (op == READ && if_new_data){
        fprintf(stderr, "Read data which doesn't exist.\n");
        assert(0);
    }

#ifdef MEASURE_FUNC_TIME
    time_Retrieve_LeafLabel = time_Retrieve_LeafLabel + rdtsc() - begin;
#endif

    return if_new_data;
}

void Fetch_Blocks(int op, int id, int* data_ptr, int access_leaf, int new_leaf, int if_new_data){
#ifdef MEASURE_FUNC_TIME
    uint64_t begin = rdtsc();
#endif

    /// Dump a whole root_to_access_leaf path from ORAM_Tree to Stash
    int stash_idx = 0;
    int bucket_idx = 1;
    int path_dir = bitwiseReverse(access_leaf, oram_tree.depth-1);

    /// Fetch the Path(length = Z*depth) to the front of stash
    for (int i = 0; i < oram_tree.depth; i++) {
        for (int j = 0; j < oram_controller.bucket_size; j++) {
            dassert(!oram_controller.stash.info[stash_idx].valid);

            ORAM_Block* oram_block = &oram_tree.oram[(bucket_idx * oram_controller.bucket_size + j) * (sizeof(ORAM_Block) / sizeof(int) + oram_controller.block_size)];
            int*        oram_data  = &oram_tree.oram[(bucket_idx * oram_controller.bucket_size + j) * (sizeof(ORAM_Block) / sizeof(int) + oram_controller.block_size) + sizeof(ORAM_Block) / sizeof(int)];
            Stash_Info* stash_info = &oram_controller.stash.info[stash_idx];
            int*        stash_data = &oram_controller.stash.data[stash_idx * oram_controller.block_size];

            // dump matadata from ORAM_Tree to Stash
            stash_info->valid = oram_block->valid;
            stash_info->id    = oram_block->id;
            stash_info->leaf  = oram_block->leaf;
            oram_block->valid = 0;
            // dump data from ORAM_Tree to Stash
            for (int k = 0; k < oram_controller.block_size; k++)
                stash_data[k] = oram_data[k];

            stash_idx++;
        }
        bucket_idx = bucket_idx * 2 + path_dir % 2;
        path_dir = path_dir / 2;
    }

    // TODO: deal with overflow strictly
    dassert(!Stash_Full());

#ifdef MEASURE_FUNC_TIME
    time_Fetch_Blocks_1 = time_Fetch_Blocks_1 + rdtsc() - begin;
    begin = rdtsc();
#endif

    /// Read / Write Stash with data_ptr and new_leaf
    int did_write = 0;
    for (int i = 0; i < oram_controller.stash.size; i++) {
        Stash_Info* stash_info_ptr = &oram_controller.stash.info[i];
        int*        stash_data_ptr = &oram_controller.stash.data[i*oram_controller.block_size];

        // if id is in stash, we read / write the corresponding stash entry
        int id_match   = (stash_info_ptr->id == id) && stash_info_ptr->valid;
        int read_cond  = id_match && (op == READ);
        int write_cond = id_match && (op == WRITE);

        cmov (id_match,   &new_leaf,      &stash_info_ptr->leaf);
        cmovn(read_cond,  stash_data_ptr, data_ptr,       oram_controller.block_size);
        cmovn(write_cond, data_ptr,       stash_data_ptr, oram_controller.block_size);

        // if id is new, we create new entry in stash
        int write_new_block = if_new_data && !stash_info_ptr->valid && !did_write;
        did_write = did_write || write_new_block;

        cmov (write_new_block, &one,      &stash_info_ptr->valid);
        cmov (write_new_block, &id,       &stash_info_ptr->id);
        cmov (write_new_block, &new_leaf, &stash_info_ptr->leaf);
        cmovn(write_new_block, data_ptr,  stash_data_ptr, oram_controller.block_size);
    }

#ifdef MEASURE_FUNC_TIME
    time_Fetch_Blocks_2 = time_Fetch_Blocks_2 + rdtsc() - begin;
#endif
}

void Store_Blocks(int access_leaf){
#ifdef MEASURE_FUNC_TIME
    uint64_t begin = rdtsc();
#endif

    for (int i = 0; i < oram_tree.depth * oram_controller.bucket_size; i++)
        wb_path[i] = -1;
    for (int i = 0; i< oram_tree.depth; i++)
        occupied[i] = 0;

    for (int i = 0; i < oram_controller.stash.size; i++) {
        int valid = oram_controller.stash.info[i].valid;
        int leaf  = oram_controller.stash.info[i].leaf;

        // Note: we have to hide level from now on, because access_leaf is already revealed. If the adversary knows 
        // what level is, they can infer what leaf is. And since we are doing sequential access(we never shuffle stash
        // after we fetch the path), the adversary knows what leaf each block on the path is mapped to!!!
        int level = PushBack(access_leaf, leaf, occupied, oram_tree.depth);

        int cond = (valid && level > -1);

        // offset = level * bucket_size + occupied[level] -- compute offset by level and occupied[level]
        int occupied_level = 0;
        ScanORAM_Read(occupied, oram_tree.depth, 1, &occupied_level, level);    // HOT CODE
        int offset = level * oram_controller.bucket_size + occupied_level;

        // comv(cond, &i, &wb_path[offset])  -- set wb_path[offset] to stash idx if valid
        int wb_path_offset = 0;
        cmov(cond, &i, &wb_path_offset);
        ScanORAM_Write(wb_path, oram_tree.depth * oram_controller.bucket_size, 1, &wb_path_offset, offset); // HOT CODE

        // cmov(cond, &inc_occupied, &occupied[level]) -- increment occupied[level]
        int inc_occupied = occupied_level + 1;
        cmov(cond, &inc_occupied, &occupied_level);
        ScanORAM_Write(occupied, oram_tree.depth, 1, &occupied_level, level);   // HOT CODE

        cmov(cond,  &offset,  &oram_controller.stash.info[i].key);
        cmov(!cond, &max_int, &oram_controller.stash.info[i].key);
    }

    // go through wb_path, write LZ ... and load stash with keys    // can be optimized
    for (int i = 0; i < oram_tree.depth * oram_controller.bucket_size; i++) {
        int if_add_extra_key = (wb_path[i] == -1);
        int add_extra_key_done = 0;
        for (int j = 0; j < oram_controller.stash.size; j++) {
            int cond = if_add_extra_key && !add_extra_key_done && !oram_controller.stash.info[j].valid;
            cmov(cond, &i, &oram_controller.stash.info[j].key);
            add_extra_key_done = add_extra_key_done || cond;
        }
        dassert((!if_add_extra_key) || (if_add_extra_key && add_extra_key_done));
    }

#ifdef MEASURE_FUNC_TIME
    uint64_t sort_begin = rdtsc();
#endif
    // ZeroTrace pass around this by storing stash into ELRange
    (*store_sort_func)((int*)oram_controller.stash.info, oram_controller.stash.data, oram_controller.stash.size, 0, 1, 1, 1, sizeof(Stash_Info) / sizeof(int), oram_controller.block_size);

#ifdef MEASURE_FUNC_TIME
    time_Sort = time_Sort + rdtsc() - sort_begin;
#endif

    int bucket_idx = 1;
    int wb_stash_idx = 0;
    int path_dir = bitwiseReverse(access_leaf, oram_tree.depth-1);
    for (int i = 0; i < oram_tree.depth; i++){
        for (int j = 0; j < oram_controller.bucket_size; j++){
            ORAM_Block* oram_block = &oram_tree.oram[(bucket_idx * oram_controller.bucket_size + j) * (sizeof(ORAM_Block) / sizeof(int) + oram_controller.block_size)];
            int*        oram_data  = &oram_tree.oram[(bucket_idx * oram_controller.bucket_size + j) * (sizeof(ORAM_Block) / sizeof(int) + oram_controller.block_size) + sizeof(ORAM_Block) / sizeof(int)];
            Stash_Info* stash_info = &oram_controller.stash.info[wb_stash_idx];
            int*        stash_data = &oram_controller.stash.data[wb_stash_idx * oram_controller.block_size];

            oram_block->valid = stash_info->valid;
            oram_block->id    = stash_info->id;
            oram_block->leaf  = stash_info->leaf;
            stash_info->valid = 0;
            for (int k = 0; k < oram_controller.block_size; k++)
                oram_data[k] = stash_data[k];
            /*cmov (if_move, &oram_controller.stash.info[wb_stash_idx].valid, &oram_block->valid); // do not movve pointer*/
            /*cmov (if_move, &oram_controller.stash.info[wb_stash_idx].id,    &oram_block->id); // do not movve pointer*/
            /*cmov (if_move, &oram_controller.stash.info[wb_stash_idx].leaf,  &oram_block->leaf); // do not movve pointer*/
            /*cmov (if_move, &zero, &(oram_controller.stash.info[wb_stash_idx].valid));*/
            /*cmovn(if_move, &oram_controller.stash.data[wb_stash_idx * oram_controller.block_size], oram_data, oram_controller.block_size);*/

            wb_stash_idx ++;
        }
        bucket_idx = bucket_idx * 2 + path_dir % 2;
        path_dir = path_dir / 2;
    }

#ifdef MEASURE_FUNC_TIME
    time_Store_Blocks = time_Store_Blocks + rdtsc() - begin;
#endif
}

/// ORAM access logic refers to ZeroTrace mechanism
void Access_ORAM (int op, int id, int* data_ptr) {
#ifdef MEASURE_FUNC_TIME
    uint64_t begin = rdtsc();
#endif

    assert (op == READ || op == WRITE);
    if (id < 0 || id >= oram_controller.pos_map.size){
        fprintf(stderr, "id = %d access fails: user declared N = %d\n", id, oram_controller.pos_map.size);
        assert(0);
    }

    int access_leaf = GenRandLeaf();
    int new_leaf = GenRandLeaf();

    int if_new_data = Retrieve_LeafLabel(op, id, &access_leaf, &new_leaf);

    Fetch_Blocks(op, id, data_ptr, access_leaf, new_leaf, if_new_data);

    Store_Blocks(access_leaf);

#ifdef MEASURE_FUNC_TIME
    time_Access_ORAM = time_Access_ORAM + rdtsc() - begin;
#endif
}

void Func_Time_Measure_Begin(){
#ifndef M2S
#ifdef MEASURE_FUNC_TIME
    time_Free_ORAM            = 0;
    time_Init_ORAM            = 0;
    time_Init_ORAM_Tree       = 0;
    time_Init_ORAM_Controller = 0;
    time_Init_PosMap          = 0;
    time_Init_Stash           = 0;
    time_Access_ORAM          = 0;
    time_Retrieve_LeafLabel   = 0;
    time_Store_Blocks         = 0;
    time_Fetch_Blocks_1       = 0;
    time_Fetch_Blocks_2       = 0;
    time_Sort                 = 0;
    total_time                = rdtsc();
#else
    printf("To begin function timing, turn on MEASURE_FUNC_TIME flag.\n");
#endif
#endif
}

void Print_Func_Time_Stats() {
#ifndef M2S
#ifdef MEASURE_FUNC_TIME
    total_time = rdtsc() - total_time;
    printf("time_Init_ORAM            is: %llu  (%f%%)\n", time_Init_ORAM, 100 * time_Init_ORAM / (double)(total_time));
    printf("time_Init_ORAM_Tree       is: %llu  (%f%%)\n", time_Init_ORAM_Tree, 100 * time_Init_ORAM_Tree / (double)(total_time))  ;
    printf("time_Init_ORAM_Controller is: %llu  (%f%%)\n", time_Init_ORAM_Controller, 100 * time_Init_ORAM_Controller / (double)(total_time));
    printf("time_Init_PosMap          is: %llu  (%f%%)\n", time_Init_PosMap, 100 * time_Init_PosMap / (double)(total_time));
    printf("time_Init_Stash           is: %llu  (%f%%)\n", time_Init_Stash, 100 * time_Init_Stash  / (double)(total_time));
    printf("time_Access_ORAM          is: %llu  (%f%%)\n", time_Access_ORAM, 100 * time_Access_ORAM / (double)(total_time));
    printf("time_Retrieve_LeafLabel   is: %llu  (%f%%)\n", time_Retrieve_LeafLabel, 100 * time_Retrieve_LeafLabel / (double)(total_time));
    printf("time_Fetch_Blocks_1       is: %llu  (%f%%)\n", time_Fetch_Blocks_1, 100 * time_Fetch_Blocks_1 / (double)(total_time));
    printf("time_Fetch_Blocks_2       is: %llu  (%f%%)\n", time_Fetch_Blocks_2, 100 * time_Fetch_Blocks_2 / (double)(total_time));
    printf("time_Store_Blocks         is: %llu  (%f%%)\n", time_Store_Blocks, 100 * time_Store_Blocks / (double)(total_time));
    printf("time_Sort:                is: %llu  (%f%%)\n", time_Sort, 100 * time_Sort / (double)(total_time));
    printf("total_time                is: %llu  (100%%)\n", total_time);
#else
    printf("To print function timing information, turn on MEASURE_FUNC_TIME flag.\n");
#endif
#endif
}

void Print_All() {
    Print_ORAM();
    Print_Stash();
    Print_PosMap();
}

void Print_ORAM() {
#ifdef DEBUG
    printf("\n\n==================== ORAM Tree ====================\n");
    for(int i = 0; i < oram_controller.num_buckets + 1; i++){
        printf("ORAM bucket # %d\n", i);
        for (int j = 0; j < oram_controller.bucket_size; j++) {
            ORAM_Block* block = &oram_tree.oram[(i*oram_controller.bucket_size+j) * (sizeof(ORAM_Block) / sizeof(int) + oram_controller.block_size)];
            int*        data  = &oram_tree.oram[(i*oram_controller.bucket_size+j) * (sizeof(ORAM_Block) / sizeof(int) + oram_controller.block_size) + sizeof(ORAM_Block) / sizeof(int)];
            printf("   block # %d, valid = %d, id = %d, leaf = %d\n", j, block->valid, block->id, block->leaf);
            for (int k = 0; k < oram_controller.block_size; k++)
                printf("        data[%d] = %d\n", k, data[k]);
        }
    }
#endif
}

void Print_Stash() {
#ifdef DEBUG
    printf("\n==================== ORAM Stash ====================\n");
    for(int i = 0; i < oram_controller.stash.size; i++){
        Stash_Info info = oram_controller.stash.info[i];
        int*       data = &oram_controller.stash.data[i*oram_controller.block_size];
        printf("Stash # %d, key = %d, valid = %d, id = %d, leaf = %d\n", i, info.key, info.valid, info.id, info.leaf);
        for(int j = 0; j < oram_controller.block_size; j++)
            printf("        data[%d] = %d\n", j, data[j]);
    }
#endif
}

void Print_PosMap() {
#ifdef DEBUG
    printf("\n==================== ORAM Pos Map ====================\n");
    for(int i = 0; i < oram_controller.pos_map.size; i++) {
        uint16_t entry = oram_controller.pos_map.entries[i];
        int entry_valid = (entry & POSMAP_VALID_MASK) && 1;
        int entry_leaf  = (entry & POSMAP_LEAF_MASK);
        printf("Posmap # %d (id), valid = %d, leaf = %d \n", i, entry_valid, entry_leaf);
    }
    printf("\n\n");
#endif
}

int Stash_Full(){
    for (int i = 0; i < oram_controller.stash.size; i++)
        if (!oram_controller.stash.info[i].valid)
            return 0;

    return 1;
}


