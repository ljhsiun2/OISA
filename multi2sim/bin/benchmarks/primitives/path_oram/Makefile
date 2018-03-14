

all:
	gcc main.c oram.c ../lib/misc.c ../sort/merge_sort.c ../sort/bitonic_sort.c -Wall -o oram

debug:
	gcc main.c oram.c ../lib/misc.c ../sort/merge_sort.c ../sort/bitonic_sort.c -Wall -g -o oram

opt:
	gcc main.c oram.c ../lib/misc.c ../sort/merge_sort.c ../sort/bitonic_sort.c -Wall -O3 -o oram

sim:
	gcc main.c oram.c ../lib/misc.c ../sort/merge_sort.c ../sort/bitonic_sort.c -Wall -m32 -o oram

sim_opt:
	gcc main.c oram.c ../lib/misc.c ../sort/merge_sort.c ../sort/bitonic_sort.c -Wall -m32 -O3 -o oram


all_static:
	gcc main.c oram.c ../lib/misc.c ../sort/merge_sort.c ../sort/bitonic_sort.c -Wall -static -o oram

opt_static:
	gcc main.c oram.c ../lib/misc.c ../sort/merge_sort.c ../sort/bitonic_sort.c -Wall -static -O3 -o oram

sim_static:
	gcc main.c oram.c ../lib/misc.c ../sort/merge_sort.c ../sort/bitonic_sort.c -Wall -static -m32 -o oram

sim_opt_static:
	gcc main.c oram.c ../lib/misc.c ../sort/merge_sort.c ../sort/bitonic_sort.c -Wall -static -m32 -O3 -o oram
