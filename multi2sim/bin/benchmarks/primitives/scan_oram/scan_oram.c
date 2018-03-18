#include <stdlib.h>
#include "scan_oram.h"
#include "../lib/asm.h"


void ScanORAM_Read(int* base_addr, int N, int block_sz_w, int* data, int idx){
#ifdef CISC_MODE
    ocload
#elseif RISC_MODE
    for (int i=0; i<N; i++){
        orload
        ocmov
    }
#else
    for (int i=0; i<N; i++){
        int if_move = (i == idx);
        cmovn(if_move, &base_addr[i*block_sz_w], data, block_sz_w);
    }
#endif
}

void ScanORAM_Write(int* base_addr, int N, int block_sz_w, int* data, int idx){
#ifdef CISC_MODE
    ocstore
#elseif RISC_MODE
    for (int i=0; i<N; i++){
        orload
        ocmov
        orstore
    }
#else
    for (int i=0; i<N; i++){
        int if_move = (i == idx);
        cmovn(if_move, data, &base_addr[i*block_sz_w], block_sz_w);
    }

#endif
}
