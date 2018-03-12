#include<stdio.h>
/*#include<math.h>*/

unsigned int log_2(unsigned int val){
    unsigned int result = 0;
    while(val>>=1) result ++;
    return result;
}

unsigned int reverse(unsigned int val){
    int result = 0;
    for(int i=0; i<3; i++){
        result = result << 1;
        result = result + val % 2;
        val = val / 2;
    }
    return result;
}

int main(){
    int a = 0, b = 1;
    int t1 = reverse(a) ^ reverse(b);
    int t2 = (t1 & (0-t1));
    int t3 = t2 - 1;
    /*if (t3 == 0){*/
        /*level = -1;*/
    /*}*/
    int full = 0;
    int t4 = t3 & ~full;
    int t5 = reverse(t4);
    int t6 = t5 & (0-t5);
    int t7 = reverse(t6);
    printf("leaf a = %d\n", reverse(a));
    printf("leaf b = %d\n", reverse(b));

    printf("t1 = %d\n", t1);
    printf("t2 = %d\n", t2);
    printf("t3 = %d\n", t3);
    printf("t4 = %d\n", t4);
    printf("t5 = %d\n", t5);
    printf("t6 = %d\n", t6);
    printf("t7 = %d\n", t7);
    printf("level = %d\n", log_2(t7));
}
