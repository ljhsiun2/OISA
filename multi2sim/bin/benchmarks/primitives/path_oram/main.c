#include <stdio.h>
#include <stdlib.h>
#include <assert.h>

#include "oram.h"
#include "../lib/misc.h"

/*void test(){*/
    /*int Z = 2;      // bucket size */
    /*int N = 2;     // num_real_blocks*/
    /*int B = 2;      // block size*/
    /*int C = 8;      // C*/

    /*Init_ORAM(Z, N, B, C, 0);*/

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
/*}*/


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
    /*Init_ORAM(4, 32, 1, 32);*/

    /*for (int i = 0; i < 10; i++){*/
        /*Access_ORAM(WRITE, i, &i);*/
        /*printf("\n@@@ After write id = %d\n\n", i);*/
        /*Print_All();*/
    /*}*/

    /*for (int i = 0; i < 10; i++){*/
        /*Access_ORAM(READ, i, &data);*/
        /*printf("data = %d, should be %d\n", data, i);*/
        /*Print_All();*/
    /*}*/

    /*for (int i = 10; i < 20; i++){*/
        /*Access_ORAM(WRITE, i, &i);*/
    /*}*/

    /*for (int i = 0; i < 20; i++){*/
        /*Access_ORAM(READ, i, &data);*/
        /*printf("data = %d, should be %d\n", data, i);*/
    /*}*/
    /*printf("\n");*/

    /*for (int i = 20; i < 30; i++){*/
        /*Access_ORAM(WRITE, i, &i);*/
    /*}*/

    /*for (int i = 10; i < 30; i++){*/
        /*Access_ORAM(READ, i, &data);*/
        /*printf("data = %d, should be %d\n", data, i);*/
    /*}*/
    /*printf("\n");*/

    /*for (int i = 0; i < 10; i++){*/
        /*Access_ORAM(WRITE, 10 - i, &i);*/
    /*}*/

    /*for (int i = 0; i < 10; i++){*/
        /*Access_ORAM(READ, 10 - i, &data);*/
        /*printf("data = %d, should be %d\n", data, i);*/
    /*}*/
/*}*/


int main(int argc, char** argv){

    /*test();*/
    assert(argc == 4);
    int Z = 4;//atoi(argv[1]);
    int C = 200;
    int N = atoi(argv[1]);
    int B = atoi(argv[2]);
    int sort_scheme = atoi(argv[3]);

    int num_access = 3;
    assert(num_access <= N);
 
    if (sort_scheme == MERGE_SORT)
        Init_ORAM(Z, N, B, C, MERGE_SORT);
    else if (sort_scheme == BITONIC_SORT)
        Init_ORAM(Z, N, B, C, BITONIC_SORT);
    else {
        printf("\n\n !!! ERROR: Unrecognized Sorting Scheme. \n\n");
        assert (0);
    }

    int* wr_data = (int*)malloc(sizeof(int) * 2 * num_access * B);
    for (int i = 0; i < 2 * num_access * B; i++)
        wr_data[i] = i;

    for (int i = 0; i < num_access; i++)
        Access_ORAM(WRITE, i, wr_data + i * B);

    int* rd_data = (int*)malloc(sizeof(int) * B);
    for (int i = 0; i < num_access; i++){
        Access_ORAM(READ, i, rd_data);
        for (int j = 0; j < B; j++){
            printf("%d, ", rd_data[j]);
        }
        printf("\n");
    }

    Free_ORAM();
    free(wr_data);
    free(rd_data);

    return 0;
}
