

all:
	gcc main.c path_oram.c ../scan_oram/scan_oram.c ../lib/misc.c ../lib/asm.c ../sort/merge_sort.c ../sort/bitonic_sort.c -Wall -o path_oram

debug:
	gcc main.c path_oram.c ../scan_oram/scan_oram.c ../lib/misc.c ../lib/asm.c ../sort/merge_sort.c ../sort/bitonic_sort.c -Wall -g -o path_oram

opt:
	gcc main.c path_oram.c ../scan_oram/scan_oram.c ../lib/misc.c ../lib/asm.c ../sort/merge_sort.c ../sort/bitonic_sort.c -Wall -O3 -o path_oram

sim:
	gcc main.c path_oram.c ../scan_oram/scan_oram.c ../lib/misc.c ../lib/asm.c ../sort/merge_sort.c ../sort/bitonic_sort.c -Wall -D M2S -m32 -o path_oram

sim_opt:
	gcc main.c path_oram.c ../scan_oram/scan_oram.c ../lib/misc.c ../lib/asm.c ../sort/merge_sort.c ../sort/bitonic_sort.c -Wall -D M2S -m32 -O3 -o path_oram


all_static:
	gcc main.c path_oram.c ../scan_oram/scan_oram.c ../lib/misc.c ../lib/asm.c ../sort/merge_sort.c ../sort/bitonic_sort.c -Wall -static -o path_oram

opt_static:
	gcc main.c path_oram.c ../scan_oram/scan_oram.c ../lib/misc.c ../lib/asm.c ../sort/merge_sort.c ../sort/bitonic_sort.c -Wall -static -O3 -o path_oram

sim_static:
	gcc main.c path_oram.c ../scan_oram/scan_oram.c ../lib/misc.c ../lib/asm.c ../sort/merge_sort.c ../sort/bitonic_sort.c -Wall -D M2S -static -m32 -o path_oram

sim_opt_static:
	gcc main.c path_oram.c ../scan_oram/scan_oram.c ../lib/misc.c ../lib/asm.c ../sort/merge_sort.c ../sort/bitonic_sort.c -Wall -D M2S -static -m32 -O3 -o path_oram
