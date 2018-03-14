

all:
	gcc main.c oram.c ../lib/misc.c ../sort/bitonic_sort.c -o oram

opt:
	gcc main.c oram.c ../lib/misc.c ../sort/bitonic_sort.c -O3 -o oram

sim:
	gcc main.c oram.c ../lib/misc.c ../sort/bitonic_sort.c -m32 -o oram

sim_opt:
	gcc main.c oram.c ../lib/misc.c ../sort/bitonic_sort.c -m32 -O3 -o oram


all_static:
	gcc main.c oram.c ../lib/misc.c ../sort/bitonic_sort.c -static -o oram

opt_static:
	gcc main.c oram.c ../lib/misc.c ../sort/bitonic_sort.c -static -O3 -o oram

sim_static:
	gcc main.c oram.c ../lib/misc.c ../sort/bitonic_sort.c -static -m32 -o oram

sim_opt_static:
	gcc main.c oram.c ../lib/misc.c ../sort/bitonic_sort.c -static -m32 -O3 -o oram
