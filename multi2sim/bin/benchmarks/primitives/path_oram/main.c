#include <stdio.h>
#include <stdlib.h>
#include <assert.h>

#include "oram.h"
#include "../lib/misc.h"

void test(int Z, int N, int B, int C){
    /*int Z = 4;      // bucket size */
    /*int N = 10;     // num_real_blocks*/
    /*int B = 4;      // block size*/
    /*int C = 8;      // C*/

    /*ORAM_Block* block = (ORAM_Block*) malloc(sizeof(ORAM_Block));*/
    /*printf("%p\n", &block);*/
    /*printf("%p\n", &block->valid);*/
    /*printf("%p\n", &block->id);*/
    /*printf("%p\n", &block->leaf);*/
    /*printf("%p\n", &block->data);*/
    /*if (&block->data == block + 3)*/
        /*printf("aaa\n");*/
    
    /*Init_ORAM(Z, N, B, C);*/

    /*int *wr_data = (int*)malloc(sizeof(int) * 2 * N * B);*/
    /*for (int i = 0; i < 2 * N * B; i++)*/
        /*wr_data[i] = i;*/

    /*for (int i = 0; i < N; i++){*/
        /*Access_ORAM(WRITE, i, wr_data + i * B);*/
    /*}*/

    /*int rd_data [] = {0,0,0,0};*/
    /*for (int i = 0; i < N; i++){*/
        /*Access_ORAM(READ, i, rd_data);*/
        /*printf("%d, %d, %d, %d\n", rd_data[0], rd_data[1], rd_data[2], rd_data[3]);*/
    /*}*/
}


/*void test1(){*/
    /*int data;*/
    /*Init_ORAM(2,3);*/
    /*Print_All();*/

    /*for (int i = 0; i < 5; i++){*/
        /*Access_ORAM(WRITE, i, &i);*/
    /*}*/
    /*Print_All();*/

    /*for (int i = 0; i < 4; i++){*/
        /*Access_ORAM(READ, 2*i, &data);*/
        /*printf("data = %d\n", data);*/
    /*}*/
    /*Print_All();*/
/*}*/

/*void test2(){*/
    /*int data;*/
    /*Init_ORAM(2, 4);*/

    /*for (int i = 0; i < 10; i++){*/
        /*Access_ORAM(WRITE, i, &i);*/
        /*printf("\n@@@ After write id = %d\n\n", i);*/
        /*Print_All();*/
    /*}*/

    /*for (int i = 0; i < 10; i++){*/
        /*Access_ORAM(READ, i, &data);*/
        /*printf("data = %d\n", data);*/
        /*Print_All();*/
    /*}*/

    /*for (int i = 10; i < 20; i++){*/
        /*Access_ORAM(WRITE, i, &i);*/
    /*}*/

    /*for (int i = 0; i < 20; i++){*/
        /*Access_ORAM(READ, i, &data);*/
        /*printf("data = %d\n", data);*/
    /*}*/
    /*printf("\n");*/

    /*for (int i = 20; i < 30; i++){*/
        /*Access_ORAM(WRITE, i, &i);*/
    /*}*/

    /*for (int i = 10; i < 30; i++){*/
        /*Access_ORAM(READ, i, &data);*/
        /*printf("data = %d\n", data);*/
    /*}*/
    /*printf("\n");*/

    /*for (int i = 0; i < 10; i++){*/
        /*Access_ORAM(WRITE, 10 - i, &i);*/
    /*}*/

    /*for (int i = 0; i < 10; i++){*/
        /*Access_ORAM(READ, 10 - i, &data);*/
        /*printf("data = %d\n", data);*/
    /*}*/
/*}*/


int main(int argc, char** argv){

    assert(argc == 5);
    int Z = atoi(argv[1]);
    int N = atoi(argv[2]);
    int B = atoi(argv[3]);
    int C = atoi(argv[4]);

    Init_ORAM(Z, N, B, C);

    int *wr_data = (int*)malloc(sizeof(int) * 2 * N * B);
    for (int i = 0; i < 2 * N * B; i++)
        wr_data[i] = i;

    for (int i = 0; i < N; i++){
        Access_ORAM(WRITE, i, wr_data + i * B);
    }

    int rd_data [] = {0,0,0,0};
    for (int i = 0; i < N; i++){
        Access_ORAM(READ, i, rd_data);
        printf("%d, %d, %d, %d\n", rd_data[0], rd_data[1], rd_data[2], rd_data[3]);
    }

}
