#include <stdlib.h>
#include <stdio.h>
#include <float.h>
#include <math.h>

#define INIT_SIZE 10
#define MEAN_1 17
#define MEAN_2 8
#define NUM_ITER 5 // user defined iterations for kmeans to keep going; kinda like accuracy

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


int main(){
    int c0[INIT_SIZE] = {1, 2, 13, 4, 9, 6, 10, 2, 4}; 
    // arbitrary array; use argc if you wanna use your own damned arrays
    int c1[INIT_SIZE];
    int c2[INIT_SIZE];

    int m1 = MEAN_1;
    int m2 = MEAN_2;
    int prev_m1=0, prev_m2=0, temp, temp2;
    int i, j, k;

    //while((m1 != prev_m1)&&(m2 != prev_m2))
    for(int loop = 0; loop < NUM_ITER; loop++)
    {
        i=0, j=0, k=0;
        for(i=0; i<INIT_SIZE; i++)
        {
            temp = abs(c0[i] - m1);
            temp2 = abs(c0[i] - m2);

           // printf("Temp 1 val: %d\n", temp);
           // printf("Temp 2 val: %d\n", temp2);
           // printf("Contents of c0: %d\n", c0[i]);

            int jnew = j+1;
            int knew = k+1;
            cmov((temp < temp2), &c0[i], &c1[j]);
            cmov((temp < temp2), &jnew, &j);

            cmov((temp >= temp2), &c0[i], &c2[k]);
            cmov((temp >= temp2), &knew, &k);
           /* if(temp < temp2)
            {
                c1[j] = c0[i];
                j++;
            }
            else
            {
                c2[k] = c0[i];
                k++;
            } */
        }

        temp = 0;
        for(i = 0; i<j; i++)
            temp = temp+c1[i];
        m1 = temp/j;

        temp2 = 0;
        for(i = 0; i<k; i++)
            temp2 = temp2+c2[i];
        m2 = temp2/k;

        printf("\n C1: ");
        for(i = 0; i<j; i++)
            printf("%d ", c1[i]);
        printf("\n mean 1: %d", m1);

        printf("\n C2: ");
        for(i = 0; i<k; i++)
            printf("%d ", c2[i]);
        printf("\n mean 2: %d", m2);

        prev_m1 = m1;
        prev_m2 = m2;
    }

    printf("\nI have no idea what I'm doing but here's some garbage\n");
    return 0;
}
