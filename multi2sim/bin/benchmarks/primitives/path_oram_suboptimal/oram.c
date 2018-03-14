#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#include "oram.h"
#include "../sort/sort.h"
#include "../lib/misc.h"

int seed    = 12345;
int zero    = 0;
int one     = 1;
int max_int = 0xfffffff;

ORAM_Tree       oram_tree;
ORAM_Controller oram_controller;

// data structure used in store blocks
int* wb_path = NULL;
int* occupied = NULL;

#ifdef MEASURE_FUNC_TIME
uint64_t time_Free_ORAM             = 0;
uint64_t time_Init_ORAM             = 0;
uint64_t time_Init_ORAM_Tree        = 0;
uint64_t time_Init_ORAM_Controller  = 0;
uint64_t time_Init_PosMap           = 0;
uint64_t time_Init_Stash            = 0;
uint64_t time_Access_ORAM           = 0;
uint64_t time_Retrieve_LeafLabel    = 0;
uint64_t time_Store_Blocks          = 0;
uint64_t time_Fetch_Blocks          = 0;
#endif



static inline void cmov(int cond, int* src_ptr, int* dst_ptr){
    __asm__ __volatile__ (  "movl (%2), %%eax\n\t"
                            "testl %0, %0\n\t"
                            "cmovnel (%1), %%eax\n\t"
                            "movl %%eax, (%2)"
                            :
                            : "b" (cond), "c" (src_ptr), "d" (dst_ptr)
                            : "cc", "%eax", "memory"
            );
}

static inline void cmovn(int cond, int* src_ptr, int* dst_ptr, int sz){
    for(int i = 0; i < sz; i++){
        /*printf("src_ptr+i = %p, dst_ptr+i = %p\n", src_ptr+i, dst_ptr+i);*/
        cmov(cond, src_ptr+i, dst_ptr+i);
    }
}

int GenRandLeaf () {  // TODO: consider using TRNG
    int result = rand() % oram_controller.num_leaves;
    return result;
}

int PushBack(int accessed_leaf, int stash_leaf, int* occupied, int L){
    int result = 0;

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
    oram_controller.stash.info = (Stash_Info*) malloc(sizeof(Stash_Info) * stash_size);
    oram_controller.stash.data = (int*) malloc(sizeof(int) * oram_controller.block_size * stash_size);

    for (int i = 0; i < oram_controller.stash.size; i++)
        oram_controller.stash.info[i].valid = 0;

#ifdef MEASURE_FUNC_TIME
    time_Init_Stash = time_Init_Stash + rdtsc() - begin;
#endif
}

void Init_PosMap (int posmap_size) {
#ifdef MEASURE_FUNC_TIME
    uint64_t begin = rdtsc();
#endif

    oram_controller.pos_map.size    = posmap_size;
    oram_controller.pos_map.entries = (PosMap_Entry*) malloc(sizeof(PosMap_Entry) * posmap_size);

    for (int i = 0; i < oram_controller.pos_map.size; i++)
        oram_controller.pos_map.entries[i].valid = 0;

#ifdef MEASURE_FUNC_TIME
    time_Init_PosMap = rdtsc() - begin;
#endif
}

void Init_ORAM_Controller (int bucket_size, int oram_depth, int block_size, int num_real_blocks, int C) {
#ifdef MEASURE_FUNC_TIME
    uint64_t begin = rdtsc();
#endif

    oram_controller.block_size  = block_size;
    oram_controller.bucket_size = bucket_size;
    oram_controller.num_buckets = (1 << oram_depth) - 1;
    oram_controller.num_leaves  = 1 << (oram_depth - 1);

    int posmap_size = bucket_size * ( (1 << oram_depth) - 1 );
    int stash_size = roundToPowerOf2(oram_controller.bucket_size * log_2(num_real_blocks) + C);

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
    oram_tree.oram  = (ORAM_Bucket*) malloc(sizeof(ORAM_Bucket) * (1 << oram_depth));

    for (int i = 0; i < (1<<oram_depth); i++) {
        oram_tree.oram[i].blocks = (ORAM_Block*) malloc(sizeof(ORAM_Block) * bucket_size);
        for (int j = 0; j < bucket_size; j++) {
            oram_tree.oram[i].blocks[j].valid = 0;
            oram_tree.oram[i].blocks[j].data = (int*) malloc(sizeof(int) * block_size);
        }
    }

#ifdef MEASURE_FUNC_TIME
    time_Init_ORAM_Tree = time_Init_ORAM_Tree + rdtsc() - begin;
#endif
}

void Init_ORAM (int bucket_size, int num_real_blocks, int block_size, int C) {
#ifdef MEASURE_FUNC_TIME
    uint64_t begin = rdtsc();
#endif

    srand(seed);
    int oram_depth = log_2(num_real_blocks) + 1;

    Init_ORAM_Controller(bucket_size, oram_depth, block_size, num_real_blocks, C);
    Init_ORAM_Tree(bucket_size, oram_depth, block_size);

    wb_path = (int*) malloc(sizeof(int) * oram_tree.depth * oram_controller.bucket_size);
    occupied = (int*) malloc(sizeof(int) * oram_tree.depth);

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

    /// Free oram
    for(int i = 0; i < (1<<oram_tree.depth); i++){
        for(int j = 0; j < oram_controller.bucket_size; j++){
            free(oram_tree.oram[i].blocks[j].data);
        }
        free(oram_tree.oram[i].blocks);
    }
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

    int new_id_deployed    = 0;
    int modify_exist_entry = 0;
    int add_new_entry      = 0;
    for (int i = 0; i < oram_controller.pos_map.size; i++) {
        PosMap_Entry* posmap_entry = &oram_controller.pos_map.entries[i];

        // if id is found in posmap, access the associated path
        modify_exist_entry = (id == posmap_entry->id) && posmap_entry->valid;
        cmov(modify_exist_entry, &posmap_entry->leaf, access_leaf_ptr);
        cmov(modify_exist_entry, new_leaf_ptr, &posmap_entry->leaf);

        // if id not found in posmap, we access an arbitrary path, and write posmap with id/leaf if op is WRITE
        add_new_entry = (op == WRITE) && !posmap_entry->valid && !new_id_deployed;
        cmov(add_new_entry, &id, &posmap_entry->id);
        cmov(add_new_entry, &one, &posmap_entry->valid);
        cmov(add_new_entry, new_leaf_ptr, &posmap_entry->leaf);

        new_id_deployed = new_id_deployed || modify_exist_entry || add_new_entry;
    }

#ifdef MEASURE_FUNC_TIME
    time_Retrieve_LeafLabel = time_Retrieve_LeafLabel + rdtsc() - begin;
#endif

    if (!new_id_deployed) {
        // all succeed
        return 1;   // all succeed
    } else {
        // op == READ, does not find the corresponding id in PosMap
        // op == WRITE, does not find the corresponding id in PosMap AND no empty slots in PosMap
        return 0;
    }
}

void Fetch_Blocks(int op, int id, int* data_ptr, int access_leaf, int new_leaf){
#ifdef MEASURE_FUNC_TIME
    uint64_t begin = rdtsc();
#endif

    /// Dump a whole root_to_access_leaf path from ORAM_Tree to Stash
    int bucket_idx = 1;
    int path_dir = bitwiseReverse(access_leaf, oram_tree.depth-1);
    for (int i = 0; i < oram_tree.depth; i++) {
        ORAM_Block* blocks = oram_tree.oram[bucket_idx].blocks;
        for (int j = 0; j < oram_controller.stash.size; j++) {
            for (int k = 0; k < oram_controller.bucket_size; k++) {
                int if_move = blocks[k].valid && !oram_controller.stash.info[j].valid;
                // dump matadata from ORAM_Tree to Stash
                cmov (if_move, &(blocks[k].valid), &(oram_controller.stash.info[j].valid));
                cmov (if_move, &(blocks[k].id),    &(oram_controller.stash.info[j].id));
                cmov (if_move, &(blocks[k].leaf),  &(oram_controller.stash.info[j].leaf));
                cmov (if_move, &zero,              &(blocks[k].valid));
                // dump data from ORAM_Tree to Stash
                cmovn(if_move, blocks[k].data,     &oram_controller.stash.data[j*oram_controller.block_size], oram_controller.block_size);
            }
        }
        bucket_idx = bucket_idx * 2 + path_dir % 2;
        path_dir = path_dir / 2;
    }

    // TODO: deal with overflow strictly
    assert(!Stash_Full());

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
        int write_new_block = !did_write && !stash_info_ptr->valid && (op == WRITE);

        did_write = did_write || write_new_block;
        cmov (write_new_block, &one,      &stash_info_ptr->valid);
        cmov (write_new_block, &id,       &stash_info_ptr->id);
        cmov (write_new_block, &new_leaf, &stash_info_ptr->leaf);
        cmovn(write_new_block, data_ptr,  stash_data_ptr, oram_controller.block_size);
    }

#ifdef MEASURE_FUNC_TIME
    time_Fetch_Blocks = time_Fetch_Blocks + rdtsc() - begin;
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
        /*printf("%d, %d, %d\n", access_leaf, leaf, oram_tree.depth);*/
        int level = PushBack(access_leaf, leaf, occupied, oram_tree.depth);

        int cond = (valid && level > -1);
        // NOTE: no need to hide offset. This offset trace will be revealed at writeback anyway

        int offset = level * oram_controller.bucket_size + occupied[level];
        cmov(cond, &i, &wb_path[offset]);

        // increment occupied[level]
        int inc_occupied = occupied[level] + 1;
        cmov(cond, &inc_occupied, &occupied[level]);

        cmov(cond,  &offset,  &oram_controller.stash.info[i].key);
        cmov(!cond, &max_int, &oram_controller.stash.info[i].key);
    }


    // ZeroTrace pass around this by storing stash into ELRange
    BitonicSort_TwoArray((int*)oram_controller.stash.info, oram_controller.stash.data, oram_controller.stash.size, 1, sizeof(Stash_Info) / sizeof(int), oram_controller.block_size);

    int bucket_idx = 1;
    int mov_stash_idx = 0;
    int path_dir = bitwiseReverse(access_leaf, oram_tree.depth-1);
    for (int i = 0; i < oram_tree.depth; i++){
        ORAM_Block* blocks = oram_tree.oram[bucket_idx].blocks;
        for (int j = 0; j < oram_controller.bucket_size; j++){
            int wb_stash_idx = wb_path[i*oram_controller.bucket_size + j];
            int if_move = wb_stash_idx != -1;

            cmov (if_move, &oram_controller.stash.info[mov_stash_idx].valid, &blocks[j].valid); // do not movve pointer
            cmov (if_move, &oram_controller.stash.info[mov_stash_idx].id,    &blocks[j].id); // do not movve pointer
            cmov (if_move, &oram_controller.stash.info[mov_stash_idx].leaf,  &blocks[j].leaf); // do not movve pointer
            cmov (if_move, &zero, &(oram_controller.stash.info[mov_stash_idx].valid));
            cmovn(if_move, &oram_controller.stash.data[mov_stash_idx * oram_controller.block_size], blocks[j].data, oram_controller.block_size);

            if (if_move) mov_stash_idx++;  // no need to hide. Will reveal to adversary anyway.
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

    int access_leaf = GenRandLeaf();
    int new_leaf = GenRandLeaf();

    int error = Retrieve_LeafLabel(op, id, &access_leaf, &new_leaf);
    if (error){
        fprintf(stderr, op == READ ? "READ" : "WRITE");
        fprintf(stderr, " id = %d failed: No such id exists, and no empty slot in ORAM.\n", id);
        assert( (op == READ && Find_PosMap(id) == -1) || (op == WRITE && Find_PosMap(id) == -1 && PosMap_Full()) );
        // must fail the check above
        fprintf(stderr, "OMG! Bug in program: check Retrieve_LeafLabel.\n");
        assert(0);
    }

    Fetch_Blocks(op, id, data_ptr, access_leaf, new_leaf);

    Store_Blocks(access_leaf);

#ifdef MEASURE_FUNC_TIME
    time_Access_ORAM = time_Access_ORAM + rdtsc() - begin;
#endif
}

void Print_Func_Time_Stats(uint64_t total_time) {
#ifdef MEASURE_FUNC_TIME
    printf("time_Init_ORAM            is: %llu  (%f%%)\n", time_Init_ORAM, 100 * time_Init_ORAM / (double)(total_time));
    printf("time_Init_ORAM_Tree       is: %llu  (%f%%)\n", time_Init_ORAM_Tree, 100 * time_Init_ORAM_Tree / (double)(total_time))  ;
    printf("time_Init_ORAM_Controller is: %llu  (%f%%)\n", time_Init_ORAM_Controller, 100 * time_Init_ORAM_Controller / (double)(total_time));
    printf("time_Init_PosMap          is: %llu  (%f%%)\n", time_Init_PosMap, 100 * time_Init_PosMap / (double)(total_time));
    printf("time_Init_Stash           is: %llu  (%f%%)\n", time_Init_Stash, 100 * time_Init_Stash  / (double)(total_time));
    printf("time_Access_ORAM          is: %llu  (%f%%)\n", time_Access_ORAM, 100 * time_Access_ORAM / (double)(total_time));
    printf("time_Retrieve_LeafLabel   is: %llu  (%f%%)\n", time_Retrieve_LeafLabel, 100 * time_Retrieve_LeafLabel / (double)(total_time));
    printf("time_Fetch_Blocks         is: %llu  (%f%%)\n", time_Fetch_Blocks, 100 * time_Fetch_Blocks / (double)(total_time));
    printf("time_Store_Blocks         is: %llu  (%f%%)\n", time_Store_Blocks, 100 * time_Store_Blocks / (double)(total_time));
#else
    printf("To print function timing information, turn on MEASURE_FUNC_TIME flag.\n");
#endif
}

void Print_All() {
#ifdef ENABLE_PRINT
    Print_ORAM();
    Print_Stash();
    Print_PosMap();
#endif
}

void Print_ORAM() {

#ifdef ENABLE_PRINT
    printf("\n\n==================== ORAM Tree ====================\n");
    for(int i = 0; i < oram_controller.num_buckets + 1; i++){
        printf("ORAM bucket # %d\n", i);
        for (int j = 0; j < oram_controller.bucket_size; j++) {
            ORAM_Block block = oram_tree.oram[i].blocks[j];
            printf("   block # %d, valid = %d, id = %d, leaf = %d\n", j, block.valid, block.id, block.leaf);
            for (int k = 0; k < oram_controller.block_size; k++)
                printf("        data[%d] = %d\n", k, block.data[k]);
        }
    }
#endif
}

void Print_Stash() {
#ifdef ENABLE_PRINT
    printf("\n==================== ORAM Stash ====================\n");
    for(int i = 0; i < oram_controller.stash.size; i++){
        Stash_Info info = oram_controller.stash.info[i];
        int*       data = oram_controller.stash.data[i*oram_controller.block_size]
        printf("Stash # %d, key = %d, valid = %d, id = %d, leaf = %d\n", i, info.key, info.valid, info.id, info.leaf);
        for(int j = 0; j < oram_controller.block_size; j++)
            printf("        data[%d] = %d\n", j, data[j]);
    }
#endif
}

void Print_PosMap() {
#ifdef ENABLE_PRINT
    printf("\n==================== ORAM Pos Map ====================\n");
    for(int i = 0; i < oram_controller.pos_map.size; i++) {
        PosMap_Entry entry = oram_controller.pos_map.entries[i];
        printf("Posmap # %d, valid = %d, id = %d, leaf = %d \n", i, entry.valid, entry.id, entry.leaf);
    }
    printf("\n\n");
#endif
}

int Find_PosMap(int id){
    int idx = -1;
    for (int i = 0; i < oram_controller.pos_map.size; i++)
        if (oram_controller.pos_map.entries[i].valid && oram_controller.pos_map.entries[i].id == id) {
            assert(idx == -1);
            idx = i;
        }

    return idx;
}

int PosMap_Full(){
    for (int i = 0; i < oram_controller.pos_map.size; i++)
        if (!oram_controller.pos_map.entries[i].valid)
            return 0;

    return 1;
}

int Stash_Full(){
    for (int i = 0; i < oram_controller.stash.size; i++)
        if (!oram_controller.stash.info[i].valid)
            return 0;

    return 1;
}

